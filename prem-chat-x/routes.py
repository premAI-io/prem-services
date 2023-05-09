from fastapi import APIRouter
from models import (
    ChatCompletionInput,
    EmbeddingsInput,
    HealthResponse,
    format_chat_response,
)
from utils import MODEL_ID, get_model

router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


@router.post("/chat/completions")
async def chat_completions(body: ChatCompletionInput):
    predictions = get_model().generate(
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

    return format_chat_response(model_name=MODEL_ID, predictions=predictions)


@router.post("/embeddings")
async def embeddings(body: EmbeddingsInput):
    return get_model().embeddings(text=body.input)
