import os

from llama_cpp import Llama

MODEL_ZOO = {
    "gpt4all-lora-q4": {"modelWeightsName": "gpt4all-lora-q4.bin"},
    "vicuna-7b-q4": {
        "modelWeightsName": "vicuna-7b-q4.bin",
    },
}


def get_model_info() -> dict:
    return MODEL_ZOO[os.getenv("MODEL_ID", None)]


class LLaMACPPBasedModel(object):
    model = None

    @classmethod
    def generate(
        cls,
        messages: list,
        temperature: float = 0.9,
        top_p: float = 0.9,
        n: int = 1,
        stream: bool = False,
        max_tokens: int = 128,
        stop: str = "",
        **kwargs,
    ):
        return cls.model.create_chat_completion(
            messages,
            temperature=temperature,
            top_p=top_p,
            stream=stream,
            stop=[stop],
            max_tokens=max_tokens,
        )

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = Llama(
                model_path=f"./ml/models/{get_model_info()['modelWeightsName']}",
                embedding=True,
            )

        return cls.model

    @classmethod
    def embeddings(cls, text):
        return cls.model.create_embedding(text)
