import os
from abc import ABC, abstractmethod
from typing import List

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, pipeline


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


class XGenBasedModel(ChatModel):
    model = None
    stopping_criteria = None

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
                num_return_sequences=n,
                temperature=temperature,
                top_p=top_p,
                eos_token_id=cls.tokenizer.eos_token_id,
                return_full_text=kwargs.get("return_full_text", False),
                do_sample=kwargs.get("do_sample", True),
                stop_sequence=stop[0] if stop else None,
            )[0]["generated_text"].rstrip(cls.tokenizer.eos_token)
        ]

    @classmethod
    def get_model(cls) -> AutoModelForCausalLM:
        if cls.model is None:
            cls.tokenizer = AutoTokenizer.from_pretrained(
                os.getenv("MODEL_ID", "Salesforce/xgen-7b-8k-inst"),
                trust_remote_code=True,
            )
            cls.model = pipeline(
                tokenizer=cls.tokenizer,
                model=os.getenv("MODEL_ID", "Salesforce/xgen-7b-8k-inst"),
                torch_dtype=torch.bfloat16,
                trust_remote_code=True,
                device_map=os.getenv("DEVICE", "auto"),
            )
        return cls.model
