export VERSION=0.0.5

docker system prune -f -a
docker buildx create --use

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest \
    --file ./cht-llama-cpp/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=vicuna-7b-q4" \
    --tag ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest \
    --tag ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./cht-llama-cpp
docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:latest \
    --file ./cht-llama-cpp/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=gpt4all-lora-q4" \
    --tag ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:latest \
    --tag ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./cht-llama-cpp
docker run --rm ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest pytest

docker system prune -f -a

docker buildx build --push \
    --cache-from ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest \
    --file ./ebd-all-minilm/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./ebd-all-minilm
docker run --rm ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest pytest

docker system prune -f -a

docker buildx build --push \
    --cache-from ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest \
    --file ./a2t-whisper/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=tiny" \
    --tag ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest \
    --tag ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./a2t-whisper
docker run --rm ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest pytest

docker system prune -f -a

docker buildx build --push \
    --cache-from ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest \
    --file ./cpl-t5/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" \
    --tag ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest \
    --tag ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:$VERSION \
    --platform linux/amd64 ./cpl-t5

docker run --rm ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest pytest

docker system prune -f -a

docker buildx build --push \
          --cache-from ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest \
          --file ./ebd-all-minilm/docker/cpu/Dockerfile \
          --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
          --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest \
          --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:$VERSION \
          --platform linux/arm64,linux/amd64 ./ebd-all-minilm

docker run --rm ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest pytest

docker system prune -f -a

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-cpu:latest \
    --file ./mlg-diffusers/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" \
    --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-cpu:latest \
    --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./mlg-diffusers
docker buildx build --push \
    --cache-from=ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest \
    --file ./mlg-diffusers/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-base" \
    --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest \
    --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./mlg-diffusers

docker run --rm ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest pytest

docker buildx create --use
docker buildx build --push \
    --cache-from=ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
    --file ./t2a-bark/docker/cpu/Dockerfile \
    --tag ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
    --tag ghcr.io/premai-io/text-to-audio-bark-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./t2a-bark

docker run --rm ghcr.io/premai-io/text-to-audio-bark-cpu:latest pytest
