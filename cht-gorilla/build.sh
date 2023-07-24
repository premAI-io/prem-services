#!/bin/bash
set -e
export VERSION=1.0.0

docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=gorilla-llm/gorilla-falcon-7b-hf-v0" \
    --tag ghcr.io/premai-io/chat-gorilla-falcon-7b-gpu:latest \
    --tag ghcr.io/premai-io/chat-gorilla-falcon-7b-gpu:$VERSION \
    .
docker run --gpus all ghcr.io/premai-io/chat-gorilla-falcon-7b-gpu:$VERSION pytest

docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=gorilla-llm/gorilla-mpt-7b-hf-v0" \
    --tag ghcr.io/premai-io/chat-gorilla-mpt-7b-gpu:latest \
    --tag ghcr.io/premai-io/chat-gorilla-mpt-7b-gpu:$VERSION \
    .
docker run --gpus all ghcr.io/premai-io/chat-gorilla-mpt-7b-gpu:$VERSION pytest
