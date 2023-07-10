import os
from abc import ABC, abstractmethod
from typing import List

import torch
from transformers import AutoConfig, AutoModelForCausalLM, AutoTokenizer


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


class Gorilla(ChatModel):
    model = None
    tokenizer = None

    @classmethod
    def generate(
        cls,
        messages: list,
        temperature: float = 0.7,
        top_p: float = 0.9,
        n: int = 1,
        stream: bool = False,
        max_tokens: int = 1024,
        stop: str = "",
        **kwargs,
    ) -> List:
        message = messages[-1]["content"]
        input_ids = cls.tokenizer([message]).input_ids
        output_ids = cls.model.generate(
            torch.as_tensor(input_ids).to("cuda"),
            temperature=temperature,
            top_p=top_p,
            num_return_sequences=n,
            eos_token_id=cls.tokenizer.eos_token_id,
            max_new_tokens=max_tokens,
            do_sample=kwargs.get("do_sample", True),
            **kwargs,
        )
        output_ids = output_ids[0][len(input_ids[0]) :]  # noqa E203
        return [cls.tokenizer.decode(output_ids, skip_special_tokens=True).strip()]

    @classmethod
    def get_model(cls) -> AutoModelForCausalLM:
        model = os.getenv("MODEL_ID", "gorilla-llm/gorilla-falcon-7b-hf-v0")
        if cls.model is None:
            if "falcon" in model:
                cls.tokenizer = AutoTokenizer.from_pretrained(
                    model,
                    trust_remote_code=True,
                )
                cls.tokenizer.pad_token = cls.tokenizer.eos_token
                cls.tokenizer.pad_token_id = 11
                cls.model = AutoModelForCausalLM.from_pretrained(
                    model,
                    trust_remote_code=True,
                    torch_dtype=torch.float16,
                    device_map=os.getenv("DEVICE", "auto"),
                )
            else:
                config = AutoConfig.from_pretrained(
                    model,
                    trust_remote_code=True,
                    init_device=os.getenv("DEVICE", "cuda:0"),
                )
                cls.tokenizer = AutoTokenizer.from_pretrained(
                    model,
                    config=config,
                    trust_remote_code=True,
                )
                cls.model = AutoModelForCausalLM.from_pretrained(
                    model,
                    config=config,
                    trust_remote_code=True,
                    torch_dtype=torch.bfloat16,
                )
        return cls.model
