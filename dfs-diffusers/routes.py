import inspect
from datetime import datetime as dt
from typing import List, Type, Union

from fastapi import APIRouter, Depends, File, Form, UploadFile
from models import DiffuserBasedModel as model
from pydantic import BaseModel
from pydantic.fields import ModelField


def as_form(cls: Type[BaseModel]):
    """
    decorator to use pydantic model with form data in fastapi;
    ref: https://stackoverflow.com/a/60670614
    """
    new_parameters = []

    for field_name, model_field in cls.__fields__.items():
        model_field: ModelField  # type: ignore

        new_parameters.append(
            inspect.Parameter(
                model_field.alias,
                inspect.Parameter.POSITIONAL_ONLY,
                default=Form(...)
                if model_field.required
                else Form(model_field.default),
                annotation=model_field.outer_type_,
            )
        )

    async def as_form_func(**data):
        return cls(**data)

    sig = inspect.signature(as_form_func)
    sig = sig.replace(parameters=new_parameters)
    as_form_func.__signature__ = sig  # type: ignore
    setattr(cls, "as_form", as_form_func)
    return cls


class ImageGenerationInput(BaseModel):
    prompt: str
    n: int = 1
    size: str = ""
    response_format: str = "b64_json"
    user: str = ""
    negative_prompt: str = None
    seed: int = None
    guidance_scale: float = 7.5
    num_inference_steps: int = 25


@as_form
class ImageEditInput(ImageGenerationInput):
    ...


class ImageObjectUrl(BaseModel):
    url: str


class ImageObjectBase64(BaseModel):
    b64_json: str


class ImageGenerationResponse(BaseModel):
    created: int = int(dt.now().timestamp())
    data: Union[List[ImageObjectUrl], List[ImageObjectBase64]]


class HealthResponse(BaseModel):
    status: bool


router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


@router.post("/images/generations", response_model=ImageGenerationResponse)
async def images_generations(body: ImageGenerationInput):
    images = model.generate(
        prompt=body.prompt,
        n=body.n,
        size=body.size,
        response_format=body.response_format,
        negative_prompt=body.negative_prompt,
        seed=body.seed,
        guidance_scale=body.guidance_scale,
        step_count=body.num_inference_steps,
    )
    return ImageGenerationResponse(created=int(dt.now().timestamp()), data=images)


@router.post("/images/edits", response_model=ImageGenerationResponse)
async def images_edits(
    image: UploadFile = File(...),
    body: ImageEditInput = Depends(ImageEditInput.as_form),
):
    images = model.generate(
        prompt=body.prompt,
        image=image,
        n=body.n,
        size=body.size,
        response_format=body.response_format,
        negative_prompt=body.negative_prompt,
        guidance_scale=body.guidance_scale,
        seed=body.seed,
        step_count=body.num_inference_steps,
    )
    return ImageGenerationResponse(created=int(dt.now().timestamp()), data=images)


@router.post("/images/upscale", response_model=ImageGenerationResponse)
async def images_upscale(
    image: UploadFile = File(...),
    body: ImageEditInput = Depends(ImageEditInput.as_form),
):
    images = model.upscale(
        prompt=body.prompt,
        image=image,
        n=body.n,
        size=body.size,
        response_format=body.response_format,
        negative_prompt=body.negative_prompt,
        guidance_scale=body.guidance_scale,
        seed=body.seed,
        step_count=body.num_inference_steps,
    )
    return ImageGenerationResponse(created=int(dt.now().timestamp()), data=images)
