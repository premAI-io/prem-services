#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest \
    --file ./a2t-whisper/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=large-v2" \
    --tag ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest \
    --tag ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:$VERSION \
    ./a2t-whisper

docker run --rm ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest pytest

docker buildx build --push \
    --cache-from ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest \
    --file ./a2t-whisper/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=tiny" \
    --tag ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest \
    --tag ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./a2t-whisper
docker run --rm ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest pytest
