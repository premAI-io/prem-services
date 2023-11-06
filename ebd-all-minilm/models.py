import os

from sentence_transformers import SentenceTransformer


class SentenceTransformerBasedModel(object):
    model = None

    @classmethod
    def embeddings(cls, texts):
        values = cls.model.encode(texts)
        return values.tolist()

    @classmethod
    def get_model(cls, model_path):
        if cls.model is None:
            cls.model = SentenceTransformer(model_path, device=os.getenv("DEVICE", "cpu"))
        return cls.model
