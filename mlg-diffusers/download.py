import argparse

from diffusers import DiffusionPipeline

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")

pipe = DiffusionPipeline.from_pretrained(args.model)
