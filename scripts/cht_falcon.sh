#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-falcon-7b-gpu:latest \
    --file ./cht-falcon/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=tiiuae/falcon-7b" \
    --tag ghcr.io/premai-io/chat-falcon-7b-gpu:latest \
    --tag ghcr.io/premai-io/chat-falcon-7b-gpu:$VERSION \
    ./cht-falcon
docker run --gpus all ghcr.io/premai-io/chat-falcon-7b-gpu:latest pytest
