import argparse

import torch
from petals import AutoDistributedModelForCausalLM
from tenacity import retry, stop_after_attempt, wait_fixed
from transformers import AutoTokenizer, LlamaTokenizer
from utils import get_cpu_architecture

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
args = parser.parse_args()

print(f"Downloading model {args.model}")


@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def download_model() -> None:
    if "llama" in args.model.lower():
        _ = LlamaTokenizer.from_pretrained(args.model)
    else:
        _ = AutoTokenizer.from_pretrained(args.model)

    if get_cpu_architecture() == "AMD":
        _ = AutoDistributedModelForCausalLM.from_pretrained(
            args.model, torch_dtype=torch.float32
        )
    else:
        _ = AutoDistributedModelForCausalLM.from_pretrained(args.model)


download_model()
