#!/bin/bash
set -e
export VERSION=1.0.1

IMAGE=ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu
docker buildx build ${@:1} \
    --file ./docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=tiny" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    --platform ${BUILDX_PLATFORM:-linux/arm64,linux/amd64} \
    .
docker run --rm $IMAGE:$VERSION pytest

IMAGE=ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=large-v2" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z ${TESTS_SKIP_GPU+x}; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi
