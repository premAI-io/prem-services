import argparse
import torch

from diffusers import StableDiffusionPipeline, StableDiffusionLatentUpscalePipeline
from tenacity import retry, stop_after_attempt, wait_fixed

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")

@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def download_model():
    if "latent" not in args.model:
        _ = StableDiffusionPipeline.from_pretrained(args.model, torch_dtype=torch.float16)
    _ = StableDiffusionLatentUpscalePipeline.from_pretrained(args.model, torch_dtype=torch.float16)
    


download_model()
