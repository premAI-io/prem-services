#!/bin/bash
set -e
export VERSION=1.1.0
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/diffuser-dalle-mini-gpu - ${@:1} \
  --build-arg="DALLE_MODEL_ID=dalle-mini/dalle-mini" \
  --build-arg="DALLE_REVISION_ID=''" \
  --build-arg="VQGAN_MODEL_ID=dalle-mini/vqgan_imagenet_f16_16384" \
  --build-arg="VQGAN_REVISION_ID=e93a26e7707683d349bf5d5c41c5b0ef69b677a9"
