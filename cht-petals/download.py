import argparse

import torch
from petals import AutoDistributedModelForCausalLM
from tenacity import retry, stop_after_attempt, wait_fixed
from transformers import AutoTokenizer, LlamaTokenizer

parser = argparse.ArgumentParser()
parser.add_argument("--model", help="Model to download")
parser.add_argument("--dht-prefix", help="DHT prefix to use")
args = parser.parse_args()

print(f"Downloading model {args.model} with DHT prefix {args.dht_prefix}")


@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def download_model() -> None:
    Tokenizer = LlamaTokenizer if "llama" in args.model.lower() else AutoTokenizer
    _ = Tokenizer.from_pretrained(args.model)
    _ = AutoDistributedModelForCausalLM.from_pretrained(args.model, torch_dtype=torch.float32, dht_prefix=args.dht_prefix)

download_model()
