#!/bin/bash
set -e
export VERSION=1.0.0

IMAGE=ghcr.io/premai-io/coder-replit-code-v1-3b-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=replit/replit-code-v1-3b" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
docker run --rm --gpus all $IMAGE:$VERSION pytest
