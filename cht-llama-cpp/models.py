import multiprocessing
import os

from llama_cpp import Llama

MODEL_ZOO = {
    "gpt4all-lora-q4": {"modelWeightsName": "gpt4all-lora-q4.bin", "ctxMaxTokens": 512},
    "vicuna-7b-q4": {"modelWeightsName": "vicuna-7b-q4.bin", "ctxMaxTokens": 512},
}
DEFAULT_N_THREADS = max(multiprocessing.cpu_count() // 2, 1)


def get_model_info() -> dict:
    return MODEL_ZOO[os.getenv("MODEL_ID", "vicuna-7b-q4")]


class LLaMACPPBasedModel(object):
    model = None

    @classmethod
    def tokenize(cls, prompt):
        return cls.model.tokenize(b" " + prompt.encode("utf-8"))

    @classmethod
    def reduce_number_of_messages(cls, messages, max_tokens):
        buffer_tokens = 32
        ctx_max_tokens = get_model_info()["ctxMaxTokens"]
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
        return cls.model.create_chat_completion(
            messages,
            temperature=temperature,
            top_p=top_p,
            stream=stream,
            stop=stop,
            max_tokens=max_tokens,
        )

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = Llama(
                model_path=f"./ml/models/{get_model_info()['modelWeightsName']}",
                embedding=True,
            )

        return cls.model

    @classmethod
    def embeddings(cls, text):
        return cls.model.create_embedding(text)
