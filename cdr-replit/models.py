import os

from transformers import AutoModelForCausalLM, AutoTokenizer


class ReplitBasedModel(object):
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
        inputs = cls.tokenizer.encode(prompt, return_tensors="pt")
        tokens = cls.model.generate(
            inputs,
            max_length=100,
            do_sample=True,
            top_p=0.95,
            top_k=4,
            temperature=0.2,
            num_return_sequences=1,
            eos_token_id=cls.tokenizer.eos_token_id,
        )
        return cls.tokenizer.decode(tokens[0], skip_special_tokens=True, clean_up_tokenization_spaces=False)

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.tokenizer = AutoTokenizer.from_pretrained(
                os.getenv("MODEL_ID", "replit/replit-code-v1-3b"),
                trust_remote_code=True,
            )
            cls.model = AutoModelForCausalLM.from_pretrained(
                os.getenv("MODEL_ID", "replit/replit-code-v1-3b"),
                trust_remote_code=True,
            )
        return cls.model
