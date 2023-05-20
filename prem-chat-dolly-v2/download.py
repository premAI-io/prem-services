import argparse

import torch
from transformers import pipeline

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")

model = pipeline(model=args.model, torch_dtype=torch.bfloat16, trust_remote_code=True)
