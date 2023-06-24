#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-2-1-base-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-1-base-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-1-base-gpu:$VERSION \
    ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=runwayml/stable-diffusion-v1-5" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu:$VERSION \
    ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-2-base-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-base" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-base-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-base-gpu:$VERSION \
    ./dfs-diffusers

docker run --rm --gpus all ghcr.io/premai-io/diffuser-stable-diffusion-2-base-gpu:latest pytest

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-2-1-base-cpu:latest \
    --file ./dfs-diffusers/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-1-base-cpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-1-base-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./dfs-diffusers
docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-2-base-cpu:latest \
    --file ./dfs-diffusers/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-base" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-base-cpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-base-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-1-5-cpu:latest \
    --file ./dfs-diffusers/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=runwayml/stable-diffusion-v1-5" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-1-5-cpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-1-5-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./dfs-diffusers

docker run --rm ghcr.io/premai-io/diffuser-stable-diffusion-2-base-cpu:latest pytest
