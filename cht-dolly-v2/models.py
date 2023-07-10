import os
from abc import ABC, abstractmethod
from typing import List

import torch
from transformers import logging, pipeline

logging.set_verbosity_error()


class ChatModel(ABC):
    @abstractmethod
    def get_model(cls):
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
    ):
        pass

    @abstractmethod
    def embeddings(cls, text):
        pass


class DollyBasedModel(ChatModel):
    model = None
    tokenizer = None

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
                temperature=temperature,
                top_p=top_p,
                num_return_sequences=n,
                return_full_text=kwargs.get("return_full_text", False),
                do_sample=kwargs.get("do_sample", True),
                stop_sequence=stop[0] if stop else None,
            )[0]["generated_text"]
        ]

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = pipeline(
                model=os.getenv("MODEL_ID", "databricks/dolly-v2-12b"),
                torch_dtype=torch.bfloat16,
                trust_remote_code=True,
                device_map=os.getenv("DEVICE", "auto"),
            )
        return cls.model
