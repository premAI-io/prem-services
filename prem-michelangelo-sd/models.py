from diffusers import DiffusionPipeline


class DiffuserBasedModel(object):
    model = None

    @classmethod
    def embeddings(cls, text):
        values = cls.model.encode([text])[0]
        return values.tolist()

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = DiffusionPipeline.from_pretrained(
                "runwayml/stable-diffusion-v1-5"
            )
            cls.model = cls.model.to()
            cls.model.enable_attention_slicing()
        return cls.model
