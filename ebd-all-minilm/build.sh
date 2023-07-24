#!/bin/bash
set -e
export VERSION=1.0.2

IMAGE=ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu
docker buildx build ${@:1} \
    --file ./docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    --platform linux/arm64,linux/amd64 \
    .
docker run --rm $IMAGE:$VERSION pytest

IMAGE=ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
docker run --rm --gpus all $IMAGE:$VERSION pytest
