from datetime import datetime as dt
from typing import List, Union

from fastapi import APIRouter
from models import DalleBasedModel as model
from pydantic import BaseModel


class ImageGenerationInput(BaseModel):
    prompt: str
    n: int = 1
    size: str = ""
    cond_scale: float = 5.0
    temperature: float = None
    top_p: float = None
    top_k: float = None
    response_format: str = "b64_json"
    user: str = ""


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


@router.post("/images/generations")
async def images_generations(body: ImageGenerationInput):
    images = model.generate(
        prompt=body.prompt,
        n=body.n,
        size=body.size,
        temperature=body.temperature,
        top_p=body.top_p,
        top_k=body.top_k,
        cond_scale=body.cond_scale,
        response_format=body.response_format,
    )
    return ImageGenerationResponse(created=int(dt.now().timestamp()), data=images)
