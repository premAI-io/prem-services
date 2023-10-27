import json
from abc import ABC, abstractmethod
from typing import Dict, List

import torch
from petals import AutoDistributedModelForCausalLM
from transformers import AutoTokenizer, LlamaTokenizer, logging, pipeline
from utils import LlamaStoppingCriteria

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
    stopping_criteria = None
    PROMPT_TEMPLATE = {}

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
        prompt = cls.stitch_prompt(messages, cls.PROMPT_TEMPLATE)
        return [
            cls.model(
                prompt,
                max_new_tokens=max_tokens,
                num_return_sequences=n,
                temperature=temperature,
                top_p=top_p,
                eos_token_id=cls.tokenizer.eos_token_id,
                return_full_text=kwargs.get("return_full_text", False),
                do_sample=kwargs.get("do_sample", True),
                stop_sequence=stop[0] if stop else None,
                stopping_criteria=cls.stopping_criteria(stop, prompt, cls.tokenizer),
            )[0]["generated_text"]
            .rstrip(stop[0] if stop else "")
            .rsplit(".", 1)[0]
            .rsplit("\n### User:")[0]
            .strip()
        ]

    @classmethod
    def get_model(
        cls,
        model_path: str = "models",
        dht_prefix: str = "StableBeluga2-hf",
        model_id: str = "petals-team/StableBeluga2",
        prompt_template_jsonstr: str = "",
    ):
        if cls.model is None:
            Tokenizer = LlamaTokenizer if "llama" in model_path.lower() else AutoTokenizer
            cls.PROMPT_TEMPLATE = json.loads(prompt_template_jsonstr)
            try:
                cls.tokenizer = Tokenizer.from_pretrained(model_path)
                model = AutoDistributedModelForCausalLM.from_pretrained(
                    model_path, torch_dtype=torch.float32, dht_prefix=dht_prefix
                )
            except EnvironmentError as e:
                print(f"Error loading model {model_id} from {model_path}: {e}")
                print("Downloading model...")
                cls.tokenizer = Tokenizer.from_pretrained(model_id)
                model = AutoDistributedModelForCausalLM.from_pretrained(
                    model_id, torch_dtype=torch.float32, dht_prefix=dht_prefix
                )
            cls.model = pipeline(
                "text-generation",
                model=model,
                tokenizer=cls.tokenizer,
                torch_dtype=torch.float32,
                model_kwargs={"dht_prefix": dht_prefix},
            )
        cls.stopping_criteria = LlamaStoppingCriteria
        return cls.model

    @staticmethod
    def stitch_prompt(messages: list, prompt_template: Dict[str, str]) -> str:
        system_prompt_template = prompt_template["system_prompt_template"]
        default_system_text = prompt_template["default_system_text"]
        user_prompt_template = prompt_template["user_prompt_template"]
        assistant_prompt_template = prompt_template["assistant_prompt_template"]
        request_assistant_response_token = prompt_template.get("request_assistant_response_token", "")

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

        return system_prompt + chat_prompt + request_assistant_response_token
