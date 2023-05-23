import uuid

from bark import SAMPLE_RATE
from fastapi import APIRouter
from models import BarkBasedModel as model
from pydantic import BaseModel
from scipy.io.wavfile import write as write_wav


class AudioGenerationInput(BaseModel):
    prompt: str


class AudioGenerationResponse(BaseModel):
    url: str


class HealthResponse(BaseModel):
    status: bool


router = APIRouter()


@router.get("/", response_model=HealthResponse)
async def health():
    return HealthResponse(status=True)


@router.post("/audio/generation")
async def audio_generation(body: AudioGenerationInput):
    audio_array = model.generate(prompt=body.prompt)
    file_name = f"{uuid.uuid4()}.wav"
    file_path = f"./files/{file_name}"
    write_wav(file_path, SAMPLE_RATE, audio_array)
    return AudioGenerationResponse(url=file_name)
