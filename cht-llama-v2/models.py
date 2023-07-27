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

    @abstractmethod
    @staticmethod
    def stitch_prompt(messages: list) -> str:
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
        prompt = cls.stitch_prompt(messages)
        return [
            cls.model(
                prompt,
                max_length=max_tokens,
                max_new_tokens=max_new_tokens,
                num_return_sequences=n,
                temperature=temperature,
                top_p=top_p,
                eos_token_id=cls.tokenizer.eos_token_id,
                return_full_text=kwargs.get("return_full_text", False),
                do_sample=kwargs.get("do_sample", True),
                stop_sequence=stop[0] if stop else None,
                stopping_criteria=cls.stopping_criteria(stop, prompt, cls.tokenizer),
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

    @staticmethod
    def stitch_prompt(messages: list) -> str:
        system_prompt_template = "<s>[INST] <<SYS>>\n{}\n<</SYS>>\n\n"  # noqa
        default_system_text = "You are a helpful, respectful and honest assistant. Always answer as helpfully as possible, while being safe.  Your answers should not include any harmful, unethical, racist, sexist, toxic, dangerous, or illegal content. Please ensure that your responses are socially unbiased and positive in nature.\n\nIf a question does not make any sense, or is not factually coherent, explain why instead of answering something not correct. If you don't know the answer to a question, please don't share false information."  # noqa
        user_prompt_template = "{} [/INST] "  # noqa
        assistant_prompt_template = "{} </s><s>[INST] "  # noqa

        system_prompt, chat_prompt = "", ""
        for message in messages:
            role = message["role"]
            content = message["content"]
            if role == "system":
                system_prompt = system_prompt_template.format(content)
            elif role == "user":
                chat_prompt += user_prompt_template.format(content)
            elif role == "assistant":
                chat_prompt += assistant_prompt_template.format(content)

        if not system_prompt:
            system_prompt = system_prompt_template.format(default_system_text)

        return system_prompt + chat_prompt
