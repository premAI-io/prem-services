import os
import uuid
from datetime import datetime as dt

from fastapi import APIRouter
from models import ReplitBasedModel as model
from pydantic import BaseModel


class ChatCompletionInput(BaseModel):
    prompt: str
    temperature: float = 1.0
    stop: str | list | None = ""
    max_tokens: int = 7


class ChatCompletionResponse(BaseModel):
    id: str = uuid.uuid4()
    model: str
    object: str = "code_completion"
    created: int = int(dt.now().timestamp())
    choices: list[dict]


class HealthResponse(BaseModel):
    status: bool


router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


@router.post("/engines/codegen/completions")
async def chat_completions(body: ChatCompletionInput):
    predictions = model.generate(
        prompt=body.prompt,
        temperature=body.temperature,
        max_tokens=body.max_tokens,
        stop=body.stop,
    )
    return {
        "id": uuid.uuid4(),
        "model": os.getenv("MODEL_ID", None),
        "object": "code_completion",
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
