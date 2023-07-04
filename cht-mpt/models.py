import os
from abc import ABC, abstractmethod
from typing import List

import torch
from transformers import AutoConfig, AutoModelForCausalLM, AutoTokenizer, pipeline
from utils import MPTStoppingCriteria


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


class MPTBasedModel(ChatModel):
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
                stopping_criteria=cls.stopping_criteria(stop, message, cls.tokenizer),
            )[0]["generated_text"]
        ]

    @classmethod
    def get_model(cls) -> AutoModelForCausalLM:
        if cls.model is None:
            config = AutoConfig.from_pretrained(
                os.getenv("MODEL_ID", "mosaicml/mpt-7b-chat"),
                trust_remote_code=True,
                max_seq_len=4096,
                init_device=os.getenv("DEVICE", "cuda:0"),
            )
            cls.tokenizer = AutoTokenizer.from_pretrained(
                "EleutherAI/gpt-neox-20b",
                config=config,
                trust_remote_code=True,
            )
            model = AutoModelForCausalLM.from_pretrained(
                os.getenv("MODEL_ID", "mosaicml/mpt-7b-chat"),
                config=config,
                trust_remote_code=True,
                torch_dtype=torch.bfloat16,
            )
            cls.model = pipeline(
                task="text-generation",
                tokenizer=cls.tokenizer,
                model=model,
                torch_dtype=torch.bfloat16,
                trust_remote_code=True,
                device=os.getenv("DEVICE", "cuda:0"),
            )
        cls.stopping_criteria = MPTStoppingCriteria
        return cls.model
