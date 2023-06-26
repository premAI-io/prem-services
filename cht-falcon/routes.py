import os
import uuid
from datetime import datetime as dt
from typing import Any, Dict, List, Optional, Union

from fastapi import APIRouter, HTTPException
from models import FalconBasedModel as model
from pydantic import BaseModel


class ChatCompletionInput(BaseModel):
    model: str
    messages: List[dict]
    temperature: float = 1.0
    top_p: float = 1.0
    n: int = 1
    stream: bool = False
    stop: Optional[Union[str, List[str]]] = ""
    max_tokens: int = 32
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
async def health() -> HealthResponse:
    return HealthResponse(status=True)


@router.post("/chat/completions", response_model=ChatCompletionResponse)
async def chat_completions(body: ChatCompletionInput) -> Dict[str, Any]:
    try:
        predictions = model.generate(
            messages=body.messages,
            temperature=body.temperature,
            top_p=body.top_p,
            n=body.n,
            stream=body.stream,
            max_tokens=body.max_tokens,
            stop=body.stop,
        )
        return ChatCompletionResponse(
            id=str(uuid.uuid4()),
            model=os.getenv("MODEL_ID", "tiiuae/falcon-7b"),
            object="chat.completion",
            created=int(dt.now().timestamp()),
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
