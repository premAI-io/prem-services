#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build ${@:1} \
    --cache-from ghcr.io/premai-io/chat-falcon-7b-instruct-gpu:latest \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=tiiuae/falcon-7b-instruct" \
    --tag ghcr.io/premai-io/chat-falcon-7b-instruct-gpu:latest \
    --tag ghcr.io/premai-io/chat-falcon-7b-instruct-gpu:$VERSION \
    .
docker run --gpus all ghcr.io/premai-io/chat-falcon-7b-instruct-gpu:latest pytest
