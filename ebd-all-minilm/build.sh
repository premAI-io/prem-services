#!/bin/bash

set -e

export VERSION=1.0.2

docker buildx build --push \
    --cache-from ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest \
    --file ./docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 .
docker run --rm ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:$VERSION pytest

docker buildx build --push \
    --cache-from ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:$VERSION \
    .
docker run --rm --gpus all ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:$VERSION pytest
