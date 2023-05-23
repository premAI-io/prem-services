import os

from transformers import AutoTokenizer, T5ForConditionalGeneration


class T5BasedModel(object):
    model = None

    @classmethod
    def generate(
        cls,
        prompt: str,
        temperature: float = 0.9,
        max_tokens: int = 128,
        stop: str = "",
        **kwargs,
    ):
        inputs = cls.tokenizer.encode(prompt, return_tensors="pt").to(
            os.getenv("DEVICE", None)
        )
        outputs = cls.model.generate(inputs, max_length=max_tokens)
        return cls.tokenizer.decode(outputs[0], skip_special_tokens=True)

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.tokenizer = AutoTokenizer.from_pretrained(os.getenv("MODEL_ID", None))
            cls.model = T5ForConditionalGeneration.from_pretrained(
                os.getenv("MODEL_ID", None)
            ).to(os.getenv("DEVICE", None))

        return cls.model
