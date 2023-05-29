import argparse

import torch
from tenacity import retry, stop_after_attempt, wait_fixed
from transformers import pipeline

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")


@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def download_model():
    _ = pipeline(model=args.model, torch_dtype=torch.bfloat16, trust_remote_code=True)


download_model()
