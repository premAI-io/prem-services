#!/bin/bash

set -e

export VERSION=1.0.3

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-2-1-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-1-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-1-gpu:$VERSION \
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
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu:$VERSION \
    ./dfs-diffusers

# docker system prune --all --force --volumes

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-x4-upscaler-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-x4-upscaler" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-x4-upscaler-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-x4-upscaler-gpu:$VERSION \
    ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-x2-latent-upscaler-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/sd-x2-latent-upscaler" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-x2-latent-upscaler-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-x2-latent-upscaler-gpu:$VERSION \
    ./dfs-diffusers

# docker run --rm --gpus all ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu:$VERSION pytest
