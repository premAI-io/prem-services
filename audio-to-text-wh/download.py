import argparse

import whisper

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")

model = whisper.load_model(args.model)
