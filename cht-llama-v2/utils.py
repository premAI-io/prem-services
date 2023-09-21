from typing import List

from transformers import StoppingCriteria


class LlamaStoppingCriteria(StoppingCriteria):
    def __init__(self, target_sequences: List[str], prompt, tokenizer) -> None:
        self.target_sequences = target_sequences
        self.prompt = prompt
        self.tokenizer = tokenizer

    def __call__(self, input_ids, scores, **kwargs) -> bool:
        if not self.target_sequences:
            return False
        # Get the generated text as a string
        generated_text = self.tokenizer.decode(input_ids[0])
        generated_text = generated_text.replace(self.prompt, "")
        # Check if the target sequence appears in the generated text
        return any(target_sequence in generated_text for target_sequence in self.target_sequences)

    def __len__(self) -> int:
        return len(self.target_sequences)

    def __iter__(self):
        yield self
