import os
import uuid
from datetime import datetime as dt
from typing import List, Optional, Union

from fastapi import APIRouter
from pydantic import BaseModel

from models import T5BasedModel as model


class ChatCompletionInput(BaseModel):
    prompt: str
    temperature: float = 1.0
    stop: Optional[Union[str, List[str]]] = ""
    max_tokens: int = 7


class ChatCompletionResponse(BaseModel):
    id: str = uuid.uuid4()
    model: str
    object: str = "code_completion"
    created: int = int(dt.now().timestamp())
    choices: List[dict]


class CodeSegment(BaseModel):
    prefix: str
    suffix: str


class CodeCompletionInput(BaseModel):
    language: str
    segments: CodeSegment


class CodeCompletionResponse(BaseModel):
    id: str = uuid.uuid4()
    choices: List[dict]


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


@router.post("/health")
async def health_tabby():
    return {"model": "TabbyML/SantaCoder-1B", "device": "cuda", "compute_type": "auto"}


@router.post("/completions")
async def chat_completions_tabby(body: CodeCompletionInput):
    text = model.generate(prompt=f"{body.segments.prefix}{body.segments.suffix}")
    return {
        "id": str(uuid.uuid4()),
        "choices": [
            {
                "index": 0,
                "text": text,
            }
        ],
    }
