import os

from sentence_transformers import SentenceTransformer


class SentenceTransformerBasedModel(object):
    model = None

    @classmethod
    def embeddings(cls, texts):
        values = cls.model.encode(texts)
        return values.tolist()

    @classmethod
    def get_model(cls, model=None):
        if cls.model is None:
            if model is None or not os.path.exists(model):
                model = os.getenv("MODEL_ID", "all-MiniLM-L6-v2")
            cls.model = SentenceTransformer(
                model,
                device=os.getenv("DEVICE", "cpu"),
            )
        return cls.model
