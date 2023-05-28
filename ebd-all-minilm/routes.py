from typing import List

from fastapi import APIRouter
from models import SentenceTransformerBasedModel as model
from pydantic import BaseModel


class EmbeddingsInput(BaseModel):
    model: str
    input: str
    user: str = ""


class EmbeddingObject(BaseModel):
    object: str = "embedding"
    index: int = 0
    embedding: List[float]


class EmbeddingUsage(BaseModel):
    prompt_tokens: int = 0
    total_tokens: int = 0


class EmbeddingsResponse(BaseModel):
    object: str = "list"
    data: List[EmbeddingObject]
    model: str = ""
    usage: EmbeddingUsage


class HealthResponse(BaseModel):
    status: bool


router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


@router.post("/embeddings", response_model=EmbeddingsResponse)
async def embeddings(body: EmbeddingsInput):
    return EmbeddingsResponse(
        object="list",
        data=[EmbeddingObject(embedding=model.embeddings(text=body.input))],
        model=body.model,
        usage=EmbeddingUsage(),
    )
