#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build ${@:1} \
    --cache-from=ghcr.io/premai-io/text-to-audio-bark-gpu:latest \
    --file ./docker/gpu/Dockerfile \
    --tag ghcr.io/premai-io/text-to-audio-bark-gpu:latest \
    --tag ghcr.io/premai-io/text-to-audio-bark-gpu:$VERSION \
    .

docker run --rm --gpus all ghcr.io/premai-io/text-to-audio-bark-gpu:$VERSION pytest

docker buildx build ${@:1} \
    --cache-from=ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
    --file ./docker/cpu/Dockerfile \
    --tag ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
    --tag ghcr.io/premai-io/text-to-audio-bark-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 .

docker run --rm ghcr.io/premai-io/text-to-audio-bark-cpu:$VERSION pytest
