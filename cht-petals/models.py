from abc import ABC, abstractmethod
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
    def get_model(
        cls,
        model_path: str = "models",
        dht_prefix: str = "StableBeluga2-hf",
        model_id: str = "petals-team/StableBeluga2",
    ):
        if cls.model is None:
            Tokenizer = LlamaTokenizer if "llama" in model_path.lower() else AutoTokenizer
            cls.tokenizer = Tokenizer.from_pretrained(model_path)
            cls.model = AutoDistributedModelForCausalLM.from_pretrained(
                model_path, torch_dtype=torch.float32, dht_prefix=dht_prefix
            )
        return cls.model
