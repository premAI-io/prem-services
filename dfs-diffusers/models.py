import base64
import io
import os
from functools import partial

import torch
from diffusers import (
    DDPMScheduler,
    DiffusionPipeline,
    StableDiffusionImg2ImgPipeline,
    StableDiffusionLatentUpscalePipeline,
    StableDiffusionPipeline,
    StableDiffusionUpscalePipeline,
)
from fastapi import UploadFile
from PIL import Image


class DiffuserBasedModel(object):
    text_img_model = None
    img_img_model = None
    upscaler_model = None
    refiner_model = None

    @classmethod
    def generate(
        cls,
        prompt: str,
        n: int,
        size: str,
        response_format: str,
        image: UploadFile = None,
        step_count: int = 25,
        negative_prompt: str = None,
        seed: int = None,
        guidance_scale: float = 7.5,
    ):
        model_fn = cls.img_img_model if image else cls.text_img_model
        generator = torch.manual_seed(seed) if seed else None
        model_fn = partial(
            model_fn,
            prompt,
            generator=generator,
            num_inference_steps=step_count,
            negative_prompt=negative_prompt,
            num_images_per_prompt=n,
            guidance_scale=guidance_scale,
        )
        if image:
            init_image = Image.open(io.BytesIO(image.file.read())).convert("RGB")
            init_image = (
                init_image.resize(tuple(map(int, (size.split("x")))))
                if size
                else init_image
            )  # breaks e.g 512x512 -> (512, 512)
            model_fn = partial(model_fn, image=init_image)
        images = model_fn(output_type="latent" if cls.refiner_model else "pil").images
        if cls.refiner_model:
            images = cls.refiner_model(prompt=prompt, image=images).images

        data = []
        for img in images:
            buffered = io.BytesIO()
            img = img.resize(tuple(map(int, (size.split("x"))))) if size else img
            img.save(buffered, format="PNG")
            data.append(
                {response_format: base64.b64encode(buffered.getvalue()).decode()}
            )
        return data

    @classmethod
    def upscale(
        cls,
        prompt: str,
        n: int,
        size: str,
        response_format: str,
        image: UploadFile = None,
        step_count: int = 25,
        negative_prompt: str = None,
        seed: int = None,
        guidance_scale: float = 7.5,
    ):
        generator = torch.manual_seed(seed) if seed else None
        # size = "300x300"
        init_image = Image.open(io.BytesIO(image.file.read())).convert("RGB")
        # print("size found:", init_image.)
        init_image = (
            init_image.resize(tuple(map(int, (size.split("x")))))
            if size
            else init_image
        )
        images = cls.upscaler_model(
            prompt=prompt,
            image=init_image,
            generator=generator,
            num_inference_steps=step_count,
            negative_prompt=negative_prompt,
            guidance_scale=guidance_scale,
        ).images

        data = []
        size = None
        for img in images:
            buffered = io.BytesIO()
            img = img.resize(tuple(map(int, (size.split("x"))))) if size else img
            img.save(buffered, format="PNG")
            data.append(
                {response_format: base64.b64encode(buffered.getvalue()).decode()}
            )
        return data

    @classmethod
    def get_model(cls):
        if cls.text_img_model is None:
            model_id = os.getenv("MODEL_ID", "stabilityai/stable-diffusion-2-1")
            print("set text img model: ", model_id)
            if "latent" in model_id:
                cls.upscaler_model = (
                    StableDiffusionLatentUpscalePipeline.from_pretrained(
                        model_id, torch_dtype=torch.float16
                    ).to(os.getenv("DEVICE", "cpu"))
                )
                cls.upscaler_model.enable_attention_slicing()
                return cls.upscaler_model
            elif "xl" in model_id:
                cls.text_img_model = DiffusionPipeline.from_pretrained(
                    os.getenv("MODEL_ID", "stabilityai/stable-diffusion-xl-base-1.0"),
                    torch_dtype=torch.float16,
                ).to(os.getenv("DEVICE", "cpu"))
                if refiner_id := os.getenv("REFINER_ID"):
                    cls.refiner_model = DiffusionPipeline.from_pretrained(
                        refiner_id,
                        torch_dtype=torch.float16,
                    ).to(os.getenv("DEVICE", "cpu"))
                cls.text_img_model.enable_attention_slicing()
                return cls.text_img_model

            cls.text_img_model = StableDiffusionPipeline.from_pretrained(
                os.getenv("MODEL_ID", "stabilityai/stable-diffusion-2-1"),
                torch_dtype=torch.float16,
            )
            cls.text_img_model = cls.text_img_model.to(os.getenv("DEVICE", "cpu"))
            cls.text_img_model.enable_attention_slicing()

            cls.img_img_model = StableDiffusionImg2ImgPipeline(
                **cls.text_img_model.components
            )
            cls.upscaler_model = StableDiffusionUpscalePipeline(
                **cls.text_img_model.components,
                low_res_scheduler=DDPMScheduler.from_config(
                    cls.text_img_model.scheduler.config
                ),
            )

        return cls.text_img_model
