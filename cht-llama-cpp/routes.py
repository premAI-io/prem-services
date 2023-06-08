import json
import uuid
from datetime import datetime as dt

from fastapi import APIRouter, HTTPException
from fastapi.responses import StreamingResponse
from models import LLaMACPPBasedModel as model
from pydantic import BaseModel


class ChatCompletionInput(BaseModel):
    model: str
    messages: list[dict]
    temperature: float = 0.2
    top_p: float = 0.95
    n: int = 1
    stream: bool = False
    stop: str | list | None = []
    max_tokens: int = 256
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


async def generate_chunk_based_response(body):
    chunks = model.generate(
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
    for chunk in chunks:
        yield f"event: completion\ndata: {json.dumps(chunk)}\n\n"
    yield "event: done\ndata: [DONE]\n\n"


@router.post("/chat/completions", response_model=ChatCompletionResponse)
async def chat_completions(body: ChatCompletionInput):
    try:
        if body.stream:
            return StreamingResponse(
                generate_chunk_based_response(body), media_type="text/event-stream"
            )
        return model.generate(
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
    except ValueError as error:
        raise HTTPException(
            status_code=400,
            detail={"message": str(error)},
        )


@router.post("/embeddings", response_model=EmbeddingsResponse)
async def embeddings(body: EmbeddingsInput):
    try:
        return model.embeddings(text=body.input)
    except ValueError as error:
        raise HTTPException(
            status_code=400,
            detail={"message": str(error)},
        )
