import os
from abc import ABC, abstractmethod
from typing import List

import torch
from transformers import AutoTokenizer, Pipeline, pipeline


class ChatModel(ABC):
    @abstractmethod
    def get_model(cls) -> None:
        pass

    @abstractmethod
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
    ) -> None:
        pass

    @abstractmethod
    def embeddings(cls, text) -> None:
        pass


class FalconBasedModel(ChatModel):
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
    ) -> List:
        message = messages[-1]["content"]
        return [
            cls.model(
                message,
                max_length=max_tokens,
                num_return_sequences=1,
                eos_token_id=cls.tokenizer.eos_token_id,
            )[0]["generated_text"]
        ]

    @classmethod
    def get_model(cls) -> Pipeline:
        if cls.model is None:
            cls.tokenizer = AutoTokenizer.from_pretrained(
                os.getenv("MODEL_ID", "tiiuae/falcon-7b"),
                trust_remote_code=True,
            )
            cls.model = pipeline(
                tokenizer=cls.tokenizer,
                model=os.getenv("MODEL_ID", "tiiuae/falcon-7b"),
                torch_dtype=torch.bfloat16,
                trust_remote_code=True,
                device_map=os.getenv("DEVICE", "auto"),
            )
        return cls.model
