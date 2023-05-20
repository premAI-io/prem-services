import argparse

from bark import preload_models

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print("Downloading model")

preload_models()
