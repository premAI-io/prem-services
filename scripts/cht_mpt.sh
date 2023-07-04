#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-mpt-7b-gpu:latest \
    --file ./cht-mpt/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=mosaicml/mpt-7b-chat" \
    --tag ghcr.io/premai-io/chat-mpt-7b-gpu:latest \
    --tag ghcr.io/premai-io/chat-mpt-7b-gpu:$VERSION \
    ./cht-mpt

docker buildx build --push \
    --cache-from ghcr.io/premai-io/mpt-7b-gpu:latest \
    --file ./cht-mpt/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=mosaicml/mpt-7b" \
    --tag ghcr.io/premai-io/mpt-7b-gpu:latest \
    --tag ghcr.io/premai-io/mpt-7b-gpu:$VERSION \
    ./cht-mpt

docker buildx build --push \
    --cache-from ghcr.io/premai-io/mpt-7b-instruct-gpu:latest \
    --file ./cht-mpt/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=mosaicml/mpt-7b-instruct" \
    --tag ghcr.io/premai-io/mpt-7b-instruct-gpu:latest \
    --tag ghcr.io/premai-io/mpt-7b-instruct-gpu:$VERSION \
    ./cht-mpt

docker run --gpus all ghcr.io/premai-io/chat-mpt-7b-gpu:latest pytest
