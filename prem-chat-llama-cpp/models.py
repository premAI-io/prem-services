from llama_cpp import Llama
from utils import get_model_info


class ChatModel:
    @classmethod
    def get_model(cls):
        pass

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
    ):
        pass

    @classmethod
    def embeddings(cls, text):
        pass


class LLaMACPPBasedModel(ChatModel):
    model = None

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
    ):
        return cls.model.create_chat_completion(
            messages,
            temperature=temperature,
            top_p=top_p,
            stream=stream,
            stop=[stop],
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
