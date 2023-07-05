#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-gorilla-7b-hf-gpu:latest \
    --file ./cht-gorilla/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=gorilla-llm/gorilla-falcon-7b-hf-v0" \
    --tag ghcr.io/premai-io/chat-gorilla-7b-hf-gpu:latest \
    --tag ghcr.io/premai-io/chat-gorilla-7b-hf-gpu:$VERSION \
    ./cht-gorilla
docker run --gpus all ghcr.io/premai-io/chat-gorilla-7b-hf-gpu:latest pytest
