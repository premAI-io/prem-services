#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-llama-2-7b-gpu:latest \
    --file ./cht-llama-v2/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=llama-2-7b-hf" \
    --tag ghcr.io/premai-io/chat-llama-2-7b-gpu:latest \
    --tag ghcr.io/premai-io/chat-llama-2-7b-gpu:$VERSION \
    ./cht-llama-v2


docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-llama-2-7b-chat-gpu:latest \
    --file ./cht-llama-v2/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=llama-2-7b-chat-hf" \
    --tag ghcr.io/premai-io/chat-llama-2-7b-chat-gpu:latest \
    --tag ghcr.io/premai-io/chat-llama-2-7b-chat-gpu:$VERSION \
    ./cht-llama-v2


docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-llama-2-13b-gpu:latest \
    --file ./cht-llama-v2/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=llama-2-13b-hf" \
    --tag ghcr.io/premai-io/chat-llama-2-13b-gpu:latest \
    --tag ghcr.io/premai-io/chat-llama-2-13b-gpu:$VERSION \
    ./cht-llama-v2


docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-llama-2-13b-chat-gpu:latest \
    --file ./cht-llama-v2/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=llama-2-13b-chat-hf" \
    --tag ghcr.io/premai-io/chat-llama-2-13b-chat-gpu:latest \
    --tag ghcr.io/premai-io/chat-llama-2-13b-chat-gpu:$VERSION \
    ./cht-llama-v2


# docker run --gpus all ghcr.io/premai-io/chat-llama-2-7b-gpu:latest pytest
