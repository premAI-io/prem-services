#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from ghcr.io/premai-io/coder-replit-code-v1-3b-gpu:latest \
    --file ./cpl-replit/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=replit/replit-code-v1-3b" \
    --tag ghcr.io/premai-io/coder-replit-code-v1-3b-gpu:latest \
    --tag ghcr.io/premai-io/coder-replit-code-v1-3b-gpu:$VERSION \
    ./cdr-replit

docker run --rm --gpus all ghcr.io/premai-io/coder-replit-code-v1-3b-gpu:$VERSION pytest
