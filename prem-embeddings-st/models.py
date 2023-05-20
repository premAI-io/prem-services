from sentence_transformers import SentenceTransformer


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


class SentenceTransformerBasedModel(ChatModel):
    model = None

    @classmethod
    def embeddings(cls, text):
        values = cls.model.encode([text])[0]
        return values.tolist()

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = SentenceTransformer(
                "sentence-transformers/all-MiniLM-L6-v2", device="cuda"
            )
        return cls.model
