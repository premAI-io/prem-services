from typing import List, Union

import tiktoken
from fastapi import APIRouter
from models import SentenceTransformerBasedModel as model
from pydantic import BaseModel


class EmbeddingsInput(BaseModel):
    model: str = None
    input: Union[List[str], List[List[int]]]
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
    model: str = None
    usage: EmbeddingUsage


class HealthResponse(BaseModel):
    status: bool


router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


@router.post("/embeddings", response_model=EmbeddingsResponse)
async def embeddings(body: EmbeddingsInput):
    values = model.embeddings(texts=body.input)
    return EmbeddingsResponse(
        object="list",
        data=[EmbeddingObject(embedding=value) for value in values],
        model=body.model,
        usage=EmbeddingUsage(),
    )


@router.post(
    "/engines/text-embedding-ada-002/embeddings", response_model=EmbeddingsResponse
)
async def embeddings_openai(body: EmbeddingsInput):
    if len(body.input) > 0 and type(body.input[0]) == list:
        encoding = tiktoken.model.encoding_for_model("text-embedding-ada-002")
        texts = encoding.decode_batch(body.input)
    else:
        texts = body.input

    values = model.embeddings(texts=texts)
    return EmbeddingsResponse(
        object="list",
        data=[EmbeddingObject(embedding=value) for value in values],
        model=body.model,
        usage=EmbeddingUsage(),
    )
