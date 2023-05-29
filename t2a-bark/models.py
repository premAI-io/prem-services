from bark import generate_audio, preload_models


class BarkBasedModel(object):
    model = None

    @classmethod
    def generate(cls, prompt: str):
        audio_array = generate_audio(prompt)
        return audio_array

    @classmethod
    def get_model(cls):
        if cls.model is None:
            preload_models()
            cls.model = {}
        return cls.model
