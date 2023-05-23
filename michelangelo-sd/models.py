import base64
import os

from diffusers import DiffusionPipeline


class DiffuserBasedModel(object):
    model = None

    @classmethod
    def generate(cls, prompt: str, n: int, size: str, response_format: str):
        images = cls.model(prompt, num_inference_steps=1).images
        data = []
        for image in images:
            data.append({"b64_json": base64.b64encode(image.tobytes())})
        return data

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = DiffusionPipeline.from_pretrained(os.getenv("MODEL_ID", None))
            cls.model = cls.model.to(os.getenv("DEVICE", "cpu"))
            cls.model.enable_attention_slicing()
        return cls.model
