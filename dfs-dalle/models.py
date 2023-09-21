import base64
import io
import os
import random
from functools import partial

import jax
import jax.numpy as jnp
import numpy as np
from dalle_mini import DalleBart, DalleBartProcessor
from flax.jax_utils import replicate
from flax.training.common_utils import shard_prng_key
from PIL import Image
from vqgan_jax.modeling_flax_vqgan import VQModel


class DalleBasedModel(object):
    model = None
    model_params = None
    decoder = None
    decoder_params = None
    processor = None

    generate_fn = None
    decode_fn = None

    rand_key = None

    @classmethod
    def generate(
        cls,
        prompt: str,
        n: int,
        size: str,
        response_format: str,
        negative_prompt: str = None,
        top_k: float = None,
        top_p: float = None,
        temperature: float = None,
        cond_scale: float = 5.0,
    ):
        seed = random.randint(0, 2**32 - 1)
        cls.rand_key = jax.random.PRNGKey(seed)
        tokenized_prompts = cls.processor([prompt])
        tokenized_prompt = replicate(tokenized_prompts)

        data = []
        for _ in range(n):
            # get a new key
            key, subkey = jax.random.split(cls.rand_key)
            # generate images
            encoded_images = cls.generate_fn(
                tokenized_prompt,
                shard_prng_key(subkey),
                cls.model_params,
                top_k,
                top_p,
                temperature,
                cond_scale,
            )
            # remove BOS
            encoded_images = encoded_images.sequences[..., 1:]
            # decode images
            decoded_images = cls.decode_fn(encoded_images, cls.decoder_params)
            decoded_images = decoded_images.clip(0.0, 1.0).reshape((-1, 256, 256, 3))
            # no loop over decoded_images since inference on single prompt -> single image
            img = Image.fromarray(np.asarray(decoded_images[0] * 255, dtype=np.uint8))
            buffered = io.BytesIO()
            img.save(buffered, format="PNG")
            data.append({response_format: base64.b64encode(buffered.getvalue()).decode("utf-8")})

        return data

    @classmethod
    def get_model(cls):
        jax.local_device_count()

        @partial(jax.pmap, axis_name="batch", static_broadcasted_argnums=(3, 4, 5, 6))
        def p_generate(tokenized_prompt, key, params, top_k, top_p, temperature, condition_scale):
            return cls.model.generate(
                **tokenized_prompt,
                prng_key=key,
                params=params,
                top_k=top_k,
                top_p=top_p,
                temperature=temperature,
                condition_scale=condition_scale,
            )

        @partial(jax.pmap, axis_name="batch")
        def p_decode(indices, params):
            return cls.decoder.decode_code(indices, params=params)

        cls.generate_fn = p_generate
        cls.decode_fn = p_decode

        if cls.model is None:
            cls.model, params = DalleBart.from_pretrained(
                os.getenv("DALLE_MODEL_ID", "dalle-mini/dalle-mini"),
                revision=None,
                dtype=jnp.float16,
                _do_init=False,
            )
            cls.decoder, vqgan_params = VQModel.from_pretrained(
                os.getenv("VQGAN_MODEL_ID", "dalle-mini/vqgan_imagenet_f16_16384"),
                revision=os.getenv("VQGAN_REVISION_ID", "e93a26e7707683d349bf5d5c41c5b0ef69b677a9"),
                _do_init=False,
            )
            cls.processor = DalleBartProcessor.from_pretrained(
                os.getenv("DALLE_MODEL_ID", "dalle-mini/dalle-mini"), revision=None
            )

            cls.model_params = replicate(params)
            cls.decoder_params = replicate(vqgan_params)

        return cls.model
