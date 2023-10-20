import os
from abc import ABC, abstractmethod
from platform import machine
from typing import List

import torch
from petals import AutoDistributedModelForCausalLM
from transformers import AutoTokenizer, LlamaTokenizer, logging

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


class PetalsBasedModel(ChatModel):
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
        inputs = cls.tokenizer(message, return_tensors="pt")["input_ids"]
        outputs = cls.model.generate(inputs, max_new_tokens=max_tokens)
        return [cls.tokenizer.decode(outputs[0])]

    @classmethod
    def get_model(cls, model_path: str, dht_prefix: str):
        if cls.model is None:
            Tokenizer = LlamaTokenizer if "llama" in os.getenv("MODEL_ID").lower() else AutoTokenizer
            cls.tokenizer = Tokenizer.from_pretrained(os.getenv("MODEL_ID"))
            cls.model = AutoDistributedModelForCausalLM.from_pretrained(
                os.getenv("MODEL_ID", model_path),
                torch_dtype=torch.float32,
                dht_prefix=os.getenv("DHT_PREFIX", dht_prefix),
            )
        return cls.model
