import os
import uuid
from datetime import datetime as dt

from fastapi import APIRouter
from models import LLaMACPPBasedModel as model
from pydantic import BaseModel


class ChatCompletionInput(BaseModel):
    model: str
    messages: list[dict]
    temperature: float = 1.0
    top_p: float = 1.0
    n: int = 1
    stream: bool = False
    stop: str | list | None = ""
    max_tokens: int = 7
    presence_penalty: float = 0.0
    frequence_penalty: float = 0.0
    logit_bias: dict | None = {}
    user: str = ""


class ChatCompletionResponse(BaseModel):
    id: str = uuid.uuid4()
    model: str
    object: str = "chat.completion"
    created: int = int(dt.now().timestamp())
    choices: list[dict]
    usage: dict = {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0}


class EmbeddingsInput(BaseModel):
    model: str
    input: str
    user: str = ""


class EmbeddingObject(BaseModel):
    object: str = "embedding"
    index: int = 0
    embedding: list[float]


class EmbeddingUsage(BaseModel):
    prompt_tokens: int = 0
    total_tokens: int = 0


class EmbeddingsResponse(BaseModel):
    object: str = "list"
    data: list[EmbeddingObject]
    model: str = ""
    usage: EmbeddingUsage


class HealthResponse(BaseModel):
    status: bool


router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


@router.post("/chat/completions")
async def chat_completions(body: ChatCompletionInput):
    predictions = model.generate(
        messages=body.messages,
        temperature=body.temperature,
        top_p=body.top_p,
        n=body.n,
        stream=body.stream,
        max_tokens=body.max_tokens,
        stop=body.stop,
        presence_penalty=body.presence_penalty,
        frequence_penalty=body.frequence_penalty,
        logit_bias=body.logit_bias,
    )
    return {
        "id": uuid.uuid4(),
        "model": os.getenv("MODEL_ID", None),
        "object": "chat.completion",
        "created": int(dt.now().timestamp()),
        "choices": [
            {
                "role": "assistant",
                "index": idx,
                "message": {"role": "assistant", "content": text},
                "finish_reason": "stop",
            }
            for idx, text in enumerate(predictions)
        ],
        "usage": {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0},
    }


@router.post("/embeddings")
async def embeddings(body: EmbeddingsInput):
    return model.embeddings(text=body.input)
