import base64
import io
import os

from diffusers import DiffusionPipeline


class DiffuserBasedModel(object):
    model = None

    @classmethod
    def generate(
        cls,
        prompt: str,
        n: int,
        size: str,
        response_format: str,
        step_count: int = 25,
        negative_prompt: str = None,
    ):
        images = cls.model(
            prompt,
            num_inference_steps=step_count,
            negative_prompt=negative_prompt,
            num_images_per_prompt=n,
        ).images
        data = []
        for image in images:
            buffered = io.BytesIO()
            image.save(buffered, format="PNG")
            data.append({"b64_json": base64.b64encode(buffered.getvalue()).decode()})
        return data

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = DiffusionPipeline.from_pretrained(
                os.getenv("MODEL_ID", "stabilityai/stable-diffusion-2-1-base")
            )
            cls.model = cls.model.to(os.getenv("DEVICE", "cpu"))
            cls.model.enable_attention_slicing()
        return cls.model
