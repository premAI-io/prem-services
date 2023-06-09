import os

from sentence_transformers import SentenceTransformer


class SentenceTransformerBasedModel(object):
    model = None

    @classmethod
    def embeddings(cls, texts):
        values = cls.model.encode(texts)
        return values.tolist()

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = SentenceTransformer(
                os.getenv("MODEL_ID", "all-MiniLM-L6-v2"),
                device=os.getenv("DEVICE", "cpu"),
            )
        return cls.model
