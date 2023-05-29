import argparse

from tenacity import retry, stop_after_attempt, wait_fixed
from transformers import AutoTokenizer, T5ForConditionalGeneration

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")


@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def download_model():
    _ = AutoTokenizer.from_pretrained(args.model)
    _ = T5ForConditionalGeneration.from_pretrained(args.model)


download_model()
