import logging
import os

from dotenv import load_dotenv

load_dotenv()

logger = logging.getLogger(__name__)

MODEL_ID = os.getenv("MODEL_ID", None)
if MODEL_ID is None:
    raise ValueError("MODEL_ID environment variable is not set.")

MODEL_ZOO = {"llama_cpp": ["gpt4all-lora-q4", "vicuna-7b-q4"]}

MODELS_INFO = [
    {
        "id": "vicuna-7b-q4",
        "name": "Vicuna 7B 1.1 Q4",
        "maxLength": 12000,
        "tokenLimit": 4000,
        "description": "Vicuna 7B 1.1 Q4",
        "modelWeightsName": "vicuna-7b-q4.bin",
        "modelWeightsSize": 4212859520,
        "modelTypes": ["chat", "embeddings"],
        "modelDevice": "m1",
    },
    {
        "id": "gpt4all-lora-q4",
        "name": "GPT4ALL-Lora Quantized GGML",
        "maxLength": 12000,
        "tokenLimit": 4000,
        "description": "GPT4ALL-Lora Quantized GGML",
        "modelWeightsName": "gpt4all-lora-q4.bin",
        "modelWeightsSize": 4212864640,
        "modelTypes": ["chat", "embeddings"],
        "modelDevice": "m1",
    },
]


def get_model_info() -> dict:
    for model in MODELS_INFO:
        if model["id"] == MODEL_ID:
            return model
    raise ValueError("Model id not supported.")


def load_model():
    if MODEL_ID in MODEL_ZOO["llama_cpp"]:
        from services.llamacpp import LLaMACPPBasedModel

        LLaMACPPBasedModel.get_model()
    else:
        raise ValueError("Model id not supported.")


def get_model():
    if MODEL_ID in MODEL_ZOO["llama_cpp"]:
        from services.llamacpp import LLaMACPPBasedModel as model

        return model
    else:
        raise ValueError("Model id not supported.")
