#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build ${@:1} \
    --cache-from=ghcr.io/premai-io/diffuser-dalle-mini-gpu:latest \
    --file ./docker/gpu/Dockerfile \
    --build-arg="DALLE_MODEL_ID=dalle-mini/dalle-mini" \
    --build-arg="DALLE_REVISION_ID=''" \
    --build-arg="VQGAN_MODEL_ID=dalle-mini/vqgan_imagenet_f16_16384" \
    --build-arg="VQGAN_REVISION_ID=e93a26e7707683d349bf5d5c41c5b0ef69b677a9" \
    --tag ghcr.io/premai-io/diffuser-dalle-mini-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-dalle-mini-gpu:$VERSION \
    .

docker run --rm --gpus all ghcr.io/premai-io/diffuser-dalle-mini-gpu:latest pytest
