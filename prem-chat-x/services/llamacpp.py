from llama_cpp import Llama
from services.interface import ChatModel
from utils import get_model_info


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
            model_parameters = get_model_info(
                f"./ml/models/{get_model_info()['modelWeightsName']}"
            )
            cls.model = Llama(
                model_path=model_parameters.get("modelWeightsPath"), embedding=True
            )

        return cls.model

    @classmethod
    def embeddings(cls, text):
        return cls.model.create_embedding(text)
