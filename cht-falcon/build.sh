#!/bin/bash
set -e
export VERSION=1.0.0

IMAGE=ghcr.io/premai-io/chat-falcon-7b-instruct-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=tiiuae/falcon-7b-instruct" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z ${TESTS_SKIP_GPU+x}; then
  docker run --gpus all $IMAGE:$VERSION pytest
fi
