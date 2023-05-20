import os

from fastapi import APIRouter, UploadFile
from models import WhisperBasedModel as inference_model
from pydantic import BaseModel


class AudioTranscriptionResponse(BaseModel):
    text: str


class HealthResponse(BaseModel):
    status: bool


router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


@router.post("/audio/transcriptions")
async def audio_transcriptions(
    file: UploadFile,
    model: str = "",
    prompt: str = "",
    response_format: str = "text",
    temperature: float = 0,
    language: str = "",
):
    file_location = f"audio_files/{file.filename}"
    os.makedirs(os.path.dirname(file_location), exist_ok=True)
    with open(file_location, "wb+") as f:
        f.write(await file.read())

    text = inference_model.transcribe(
        model=model,
        file=file_location,
        prompt=prompt,
        response_format=response_format,
        temperature=temperature,
        language=language,
    )
    return AudioTranscriptionResponse(text=text)
