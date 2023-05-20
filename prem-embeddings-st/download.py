import argparse

from sentence_transformers import SentenceTransformer

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")

model = SentenceTransformer(args.model)
