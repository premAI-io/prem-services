import os

import whisper


class WhisperBasedModel(object):
    model = None

    @classmethod
    def transcribe(
        cls,
        model: str,
        file: str,
        prompt: str,
        response_format: str,
        temperature: float,
        language: str,
    ):
        result = cls.model.transcribe(file)
        return result["text"]

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = whisper.load_model(os.getenv("MODEL_ID", "large-v2"))
        return cls.model
