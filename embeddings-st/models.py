import os

from sentence_transformers import SentenceTransformer


class SentenceTransformerBasedModel(object):
    model = None

    @classmethod
    def embeddings(cls, text):
        values = cls.model.encode([text])[0]
        return values.tolist()

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = SentenceTransformer(
                os.getenv("MODEL_ID", None), device=os.getenv("DEVICE", None)
            )
        return cls.model
