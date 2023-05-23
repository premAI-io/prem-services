import argparse

from transformers import AutoTokenizer, T5ForConditionalGeneration

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")

tokenizer = AutoTokenizer.from_pretrained(args.model)
model = T5ForConditionalGeneration.from_pretrained(args.model)
