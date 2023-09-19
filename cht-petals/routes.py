import json
import uuid
from datetime import datetime as dt
from typing import List, Optional, Union

from fastapi import APIRouter, HTTPException
from fastapi.responses import StreamingResponse
from models import PetalsBasedModel as model
from pydantic import BaseModel


class ChatCompletionInput(BaseModel):
    model: str
    messages: List[dict]
    temperature: float = 1.0
    top_p: float = 1.0
    n: int = 1
    stream: bool = False
    stop: Optional[Union[str, List[str]]] = ""
    max_tokens: int = 7
    presence_penalty: float = 0.0
    frequence_penalty: float = 0.0
    logit_bias: Optional[dict] = {}
    user: str = ""


class ChatCompletionResponse(BaseModel):
    id: str = uuid.uuid4()
    model: str
    object: str = "chat.completion"
    created: int = int(dt.now().timestamp())
    choices: List[dict]
    usage: dict = {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0}


class HealthResponse(BaseModel):
    status: bool


router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


async def generate_chunk_based_response(body, text):
    yield "event: completion\ndata: " + json.dumps(
        {
            "id": str(uuid.uuid4()),
            "model": body.model,
            "object": "chat.completion",
            "choices": [
                {
                    "role": "assistant",
                    "index": 1,
                    "delta": {"role": "assistant", "content": text},
                    "finish_reason": "stop",
                }
            ],
            "usage": {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0},
        }
    ) + "\n\n"
    yield "event: done\ndata: [DONE]\n\n"


@router.post("/chat/completions", response_model=ChatCompletionResponse)
async def chat_completions(body: ChatCompletionInput):
    try:
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
        if body.stream:
            return StreamingResponse(
                generate_chunk_based_response(body, predictions[0]),
                media_type="text/event-stream",
            )
        return ChatCompletionResponse(
            id=str(uuid.uuid4()),
            model=body.model,
            object="chat.completion",
            choices=[
                {
                    "role": "assistant",
                    "index": idx,
                    "message": {"role": "assistant", "content": text},
                    "finish_reason": "stop",
                }
                for idx, text in enumerate(predictions)
            ],
            usage={"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0},
        )
    except ValueError as error:
        raise HTTPException(
            status_code=400,
            detail={"message": str(error)},
        )
