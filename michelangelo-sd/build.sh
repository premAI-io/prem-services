docker buildx build --file ./michelangelo-sd/docker/cpu/Dockerfile --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-cpu:latest --platform linux/arm64,linux/amd64 ./michelangelo-sd
docker buildx build --file ./michelangelo-sd/docker/cpu/Dockerfile --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-base" --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest --platform linux/arm64,linux/amd64 ./michelangelo-sd

docker buildx build --file ./michelangelo-sd/docker/gpu/Dockerfile --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-gpu:latest --platform linux/arm64,linux/amd64 ./michelangelo-sd
docker buildx build --file ./michelangelo-sd/docker/gpu/Dockerfile --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-base" --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-gpu:latest --platform linux/arm64,linux/amd64 ./michelangelo-sd

docker run --rm ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-cpu:latest pytest
docker run --rm ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest pytest

docker run --rm --gpus all ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-gpu:latest pytest

docker push ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-cpu:latest
docker push ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest

docker push ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-gpu:latest
docker push ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-gpu:latest
