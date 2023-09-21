import argparse

import jax
from dalle_mini import DalleBart, DalleBartProcessor
from tenacity import retry, stop_after_attempt, wait_fixed
from vqgan_jax.modeling_flax_vqgan import VQModel

parser = argparse.ArgumentParser()
parser.add_argument("--dalle-model", help="Dalle Model to download")
parser.add_argument("--dalle-revision", help="Dalle Revision to download", default=None, required=False)
parser.add_argument("--vqgan-model", help="VQGAN Model to download")
parser.add_argument("--vqgan-revision", help="VQGAN Revision to download", default=None, required=False)
args = parser.parse_args()

jax.local_device_count()
print(f"Downloading models: \n{args.dalle_model}\n{args.vqgan_model}")


@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def download_model():
    _ = DalleBart.from_pretrained(args.dalle_model, revision=None, dtype=jax.numpy.float16, _do_init=False)
    _ = DalleBartProcessor.from_pretrained(args.dalle_model, revision=None)

    _ = VQModel.from_pretrained(args.vqgan_model, revision=args.vqgan_revision or None, _do_init=False)


download_model()
