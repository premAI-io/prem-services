#!/bin/bash

set -e

export VERSION=1.0.3

docker buildx build ${@:1} \
    --cache-from ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=databricks/dolly-v2-12b" \
    --tag ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest \
    --tag ghcr.io/premai-io/chat-dolly-v2-12b-gpu:$VERSION \
    .

docker run --gpus all ghcr.io/premai-io/chat-dolly-v2-12b-gpu:$VERSION pytest
