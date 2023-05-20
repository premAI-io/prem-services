import torch
from transformers import pipeline


class ChatModel:
    @classmethod
    def get_model(cls):
        pass

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
        pass

    @classmethod
    def embeddings(cls, text):
        pass


class DollyBasedModel(ChatModel):
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
        message = messages[-1]["content"]
        return [cls.model(message)[0]["generated_text"]]

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = pipeline(
                model="databricks/dolly-v2-12b",
                torch_dtype=torch.bfloat16,
                trust_remote_code=True,
                device_map="auto",
            )
        return cls.model
