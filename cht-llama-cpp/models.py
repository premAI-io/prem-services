import json
import multiprocessing
from typing import Any, Dict, List

from llama_cpp import Llama, llama_chat_format, llama_types

DEFAULT_N_THREADS = max(multiprocessing.cpu_count() // 2, 1)


@llama_chat_format.register_chat_format("chatml")
def initiate_chatml_prompt_template(
    messages: List[llama_types.ChatCompletionRequestMessage],
    **kwargs: Any,
) -> llama_chat_format.ChatFormatterResponse:
    # Until https://github.com/abetlen/llama-cpp-python/issues/717 supports ChatML.

    _prompt = LLaMACPPBasedModel.stitch_prompt(messages, LLaMACPPBasedModel.PROMPT_TEMPLATE)
    return llama_chat_format.ChatFormatterResponse(prompt=_prompt)


class LLaMACPPBasedModel(object):
    model = None
    PROMPT_TEMPLATE = {}

    @classmethod
    def tokenize(cls, prompt):
        return cls.model.tokenize(b" " + prompt.encode("utf-8"))

    @classmethod
    def reduce_number_of_messages(cls, messages, max_tokens):
        buffer_tokens = 32
        ctx_max_tokens = 4096
        num_messages = len(messages)

        tokens = [len(cls.tokenize(doc["content"])) for doc in messages]

        token_count = sum(tokens[:num_messages])
        while token_count + max_tokens + buffer_tokens > ctx_max_tokens:
            num_messages -= 1
            token_count -= tokens[num_messages]
        return messages[:num_messages]

    @classmethod
    def generate(
        cls,
        messages: list,
        temperature: float = 0.2,
        top_p: float = 0.95,
        n: int = 1,
        stream: bool = False,
        max_tokens: int = 256,
        stop: list = None,
        n_threads: int = DEFAULT_N_THREADS,
        **kwargs,
    ):
        if stop is None:
            stop = []
        messages = cls.reduce_number_of_messages(messages[::-1], max_tokens)[::-1]
        cls.model.n_threads = n_threads
        cht_resp = cls.model.create_chat_completion(
            messages,
            temperature=temperature,
            top_p=top_p,
            stream=stream,
            stop=stop,
            max_tokens=max_tokens,
        )
        if not stream and cls.PROMPT_TEMPLATE.get("template_format") == "chatml":
            cht_resp["choices"][0]["message"]["content"] = (
                cht_resp["choices"][0]["message"]["content"].split("\n<|im_end|>")[0].strip()
            )

        # TODO: handle postprocessing for streaming responses

        return cht_resp

    @classmethod
    def get_model(cls, model_path, prompt_template_jsonstr):
        chat_format = "llama-2"
        if "mistral" in model_path:
            cls.PROMPT_TEMPLATE = json.loads(prompt_template_jsonstr)
            chat_format = cls.PROMPT_TEMPLATE.get("template_format", "chatml")
        if cls.model is None:
            cls.model = Llama(model_path, chat_format=chat_format)

        return cls.model

    @classmethod
    def embeddings(cls, text):
        return cls.model.create_embedding(text)

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
