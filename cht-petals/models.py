import json
from abc import ABC, abstractmethod
from typing import Dict, List, Optional, Union

import torch
from petals import AutoDistributedModelForCausalLM
from transformers import AutoTokenizer, LlamaTokenizer, PreTrainedTokenizer, logging

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
    PROMPT_TEMPLATE = {}

    @classmethod
    def generate(
        cls,
        messages: list,
        stop: Optional[Union[str, List[str]]],
        temperature: float = 0.9,
        top_p: float = 0.9,
        n: int = 1,
        stream: bool = False,
        max_tokens: int = 128,
        **kwargs,
    ) -> List:
        prompt = cls.stitch_prompt(messages, cls.PROMPT_TEMPLATE)
        inputs = cls.tokenizer(prompt, return_tensors="pt")["input_ids"]
        n_input_tokens = inputs.shape[1]

        outputs = cls.model.generate(
            inputs=inputs,
            do_sample=kwargs.get("do_sample", True),
            temperature=temperature,
            top_p=top_p,
            max_new_tokens=max_tokens,
        )
        outputs = cls.safe_decode(cls.tokenizer, outputs[0, n_input_tokens:], stop_tokens=stop)
        return [outputs]

    @classmethod
    def generate_streaming(
        cls,
        messages: list,
        stop: Optional[Union[str, List[str]]],
        temperature: float = 0.9,
        top_p: float = 0.9,
        n: int = 1,
        stream: bool = False,
        max_tokens: int = 128,
        session=None,
        inputs=None,
        **kwargs,
    ) -> List:
        if inputs is not None:
            prompt = cls.stitch_prompt(messages, cls.PROMPT_TEMPLATE)
            inputs = cls.tokenizer(prompt, return_tensors="pt")["input_ids"]
            n_input_tokens = inputs.shape[1]
        else:
            n_input_tokens = 0

        outputs = cls.model.generate(
            inputs=inputs,
            do_sample=kwargs.get("do_sample", True),
            temperature=temperature,
            top_p=top_p,
            max_new_tokens=max_tokens,
            session=session,
        )
        delta = outputs[0, n_input_tokens:].tolist()
        token_count = len(delta)  # noqa
        outputs = cls.safe_decode(cls.tokenizer, delta, stop_tokens=stop)
        if not outputs:
            return None  # end
        outputs = outputs.lstrip() if inputs is not None else outputs
        return outputs

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
                cls.model = AutoDistributedModelForCausalLM.from_pretrained(
                    model_path, torch_dtype=torch.float32, dht_prefix=dht_prefix
                )
            except EnvironmentError as e:
                print(f"Error loading model {model_id} from {model_path}: {e}")
                print("Downloading model...")
                cls.tokenizer = Tokenizer.from_pretrained(model_id)
                cls.model = AutoDistributedModelForCausalLM.from_pretrained(
                    model_id, torch_dtype=torch.float32, dht_prefix=dht_prefix
                )
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

    def safe_decode(
        tokenizer: PreTrainedTokenizer,
        outputs: Union[torch.Tensor, List[int]],
        stop_tokens: Optional[Union[str, List[str]]],
    ) -> str:
        # Workaround to make SentencePiece .decode() keep leading spaces in a token
        fake_token = tokenizer("^")["input_ids"][0]
        outputs = outputs.tolist() if isinstance(outputs, torch.Tensor) else outputs
        result = tokenizer.decode([fake_token] + outputs).replace("<s>", "")

        for stop_token in stop_tokens:
            result = result.split(stop_token)[0]
        return result
