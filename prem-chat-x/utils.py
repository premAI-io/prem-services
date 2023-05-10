import logging
import os

logger = logging.getLogger(__name__)

MODEL_ID = os.getenv("MODEL_ID", None)


def get_models_info() -> dict:
    return {
        "data": [
            {
                "id": "vicuna-7b-q4",
                "name": "Vicuna 7B 1.1 Q4",
                "maxLength": 12000,
                "tokenLimit": 4000,
                "description": "Vicuna 7B 1.1 Q4",
                "modelWeightsName": "ggml-vicuna-7b-1.1-q4_2.bin",
                "modelWeightsSize": 4212859520,
                "modelTypes": ["chat", "embeddings"],
                "modelDevice": "m1",
            },
            {
                "id": "gpt4all-lora-quantized-ggml",
                "name": "GPT4ALL-Lora Quantized GGML",
                "maxLength": 12000,
                "tokenLimit": 4000,
                "description": "GPT4ALL-Lora Quantized GGML",
                "modelWeightsName": "gpt4all-lora-quantized-ggml.bin",
                "modelWeightsSize": 4212864640,
                "modelTypes": ["chat", "embeddings"],
                "modelDevice": "m1",
            },
        ]
    }


def get_model_info() -> dict:
    for model in get_models_info()["data"]:
        if model["id"] == MODEL_ID:
            return model
    raise ValueError("Model id not supported.")


def load_model():
    if MODEL_ID in ["gpt4all-lora-quantized-ggml", "ggml-vicuna-7b-1.1-q4_2"]:
        from services.llamacpp import LLaMACPPBasedModel

        LLaMACPPBasedModel.get_model()
    else:
        raise ValueError("Model id not supported.")


def get_model():
    if MODEL_ID in ["gpt4all-lora-quantized-ggml", "ggml-vicuna-7b-1.1-q4_2"]:
        from services.llamacpp import LLaMACPPBasedModel as model

        return model
    else:
        raise ValueError("Model id not supported.")
