import os
from abc import ABC, abstractmethod
from typing import List

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, Pipeline, pipeline
from utils import LlamaStoppingCriteria


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
        max_new_tokens: int = 128,
        stop: str = "",
        **kwargs,
    ) -> None:
        pass

    @abstractmethod
    def embeddings(cls, text) -> None:
        pass


class LlamaBasedModel(ChatModel):
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
        max_tokens: int = 4096,
        max_new_tokens: int = 128,
        stop: str = "",
        **kwargs,
    ) -> List:
        message = messages[-1]["content"]
        return [
            cls.model(
                message,
                max_length=max_tokens,
                max_new_tokens=max_new_tokens,
                num_return_sequences=n,
                temperature=temperature,
                top_p=top_p,
                eos_token_id=cls.tokenizer.eos_token_id,
                return_full_text=kwargs.get("return_full_text", False),
                do_sample=kwargs.get("do_sample", True),
                stop_sequence=stop[0] if stop else None,
                stopping_criteria=cls.stopping_criteria(stop, message, cls.tokenizer),
            )[0]["generated_text"].rstrip(stop[0] if stop else "")
        ]

    @classmethod
    def get_model(cls) -> Pipeline:
        if cls.model is None:
            cls.tokenizer = AutoTokenizer.from_pretrained(
                os.getenv("MODEL_ID", "llama-2-7b-chat-hf"),
                use_fast=True,
            )
            model = AutoModelForCausalLM.from_pretrained(
                os.getenv("MODEL_ID", "llama-2-7b-chat-hf"),
                device_map=os.getenv("DEVICE", "auto"),
                torch_dtype=torch.float16,
            )
            cls.model = pipeline(
                "text-generation",
                tokenizer=cls.tokenizer,
                model=model,
                torch_dtype=torch.float16,
                device_map=os.getenv("DEVICE", "auto"),
            )
        cls.stopping_criteria = LlamaStoppingCriteria
        return cls.model
