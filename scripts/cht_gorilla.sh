#!/bin/bash

set -e

export VERSION=1.0.0

echo "Build, push and test gorilla falcon"

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-gorilla-falcon-7b-gpu:latest \
    --file ./cht-gorilla/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=gorilla-llm/gorilla-falcon-7b-hf-v0" \
    --tag ghcr.io/premai-io/chat-gorilla-falcon-7b-gpu:latest \
    --tag ghcr.io/premai-io/chat-gorilla-falcon-7b-gpu:$VERSION \
    ./cht-gorilla

docker run -e MODEL_ID=gorilla-llm/gorilla-falcon-7b-hf-v0 --gpus all ghcr.io/premai-io/chat-gorilla-falcon-7b-gpu:latest pytest

echo "Build, push and test gorilla mpt"

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-gorilla-mpt-7b-gpu:latest \
    --file ./cht-gorilla/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=gorilla-llm/gorilla-mpt-7b-hf-v0" \
    --tag ghcr.io/premai-io/chat-gorilla-mpt-7b-gpu:latest \
    --tag ghcr.io/premai-io/chat-gorilla-mpt-7b-gpu:$VERSION \
    ./cht-gorilla

docker run -e MODEL_ID=gorilla-llm/gorilla-mpt-7b-hf-v0 --gpus all ghcr.io/premai-io/chat-gorilla-mpt-7b-gpu:latest pytest
