import logging
import os

from dotenv import load_dotenv

load_dotenv()

logger = logging.getLogger(__name__)

MODEL_ID = os.getenv("MODEL_ID", None)
if MODEL_ID is None:
    raise ValueError("MODEL_ID environment variable is not set.")

MODEL_ZOO = {
    "llama_cpp": {
        "gpt4all-lora-q4": {"modelWeightsName": "gpt4all-lora-q4.bin"},
        "vicuna-7b-q4": {
            "modelWeightsName": "vicuna-7b-q4.bin",
        },
    }
}


def get_model_info() -> dict:
    for _, value in MODEL_ZOO.items():
        for id, model in value.items():
            if id == MODEL_ID:
                return model
    raise ValueError("Model id not supported.")


def load_model():
    if MODEL_ID in MODEL_ZOO["llama_cpp"].keys():
        from models import LLaMACPPBasedModel

        LLaMACPPBasedModel.get_model()
    else:
        raise ValueError("Model id not supported.")


def get_model():
    if MODEL_ID in MODEL_ZOO["llama_cpp"].keys():
        from models import LLaMACPPBasedModel as model

        return model
    else:
        raise ValueError("Model id not supported.")
