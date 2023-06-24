#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest \
    --file ./cht-dolly-v2/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=databricks/dolly-v2-12b" \
    --tag ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest \
    --tag ghcr.io/premai-io/chat-dolly-v2-12b-gpu:$VERSION \
    ./cht-dolly-v2
docker run --gpus all ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest pytest
