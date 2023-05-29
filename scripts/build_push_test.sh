export VERSION=0.0.1

docker system prune -f -a
docker buildx create --use

# docker buildx build --push \
#     --cache-from ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest \
#     --file ./a2t-whisper/docker/cpu/Dockerfile \
#     --build-arg="MODEL_ID=tiny" \
#     --tag ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest \
#     --platform linux/arm64,linux/amd64 ./a2t-whisper
# docker buildx build --push \
#     --cache-from ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest \
#     --file ./a2t-whisper/docker/gpu/Dockerfile \
#     --build-arg="MODEL_ID=large-v2" \
#     --tag ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest \
#     --platform linux/amd64 ./a2t-whisper
# docker run --rm ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest pytest
# docker run --rm ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest pytest

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest \
    --file ./cht-dolly-v2/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=databricks/dolly-v2-12b" \
    --tag ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest \
    --tag ghcr.io/premai-io/chat-dolly-v2-12b-gpu:$VERSION \
    --platform linux/amd64 ./cht-dolly-v2
docker run --gpus all ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest pytest

docker system prune -f -a

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


# docker buildx build --push \
#     --cache-from ghcr.io/premai-io/copilot-replit-code-v1-3b-gpu:latest \
#     --file ./cpl-replit/docker/gpu/Dockerfile \
#     --build-arg="MODEL_ID=replit/replit-code-v1-3b" \
#     --tag ghcr.io/premai-io/copilot-replit-code-v1-3b-gpu:latest \
#     --platform linux/amd64 ./cpl-replit
# docker run --rm --gpus all ghcr.io/premai-io/copilot-replit-code-v1-3b-gpu:latest pytest

# docker buildx build --push \
#     --cache-from ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest \
#     --file ./cpl-t5/docker/cpu/Dockerfile \
#     --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" \
#     --tag ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest \
#     --platform linux/amd64 ./cpl-t5
# docker run --rm ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest pytest

docker buildx build --push \
    --cache-from ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest \
    --file ./ebd-all-minilm/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./ebd-all-minilm
docker buildx build --push \
    --cache-from ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest \
    --file ./ebd-all-minilm/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:$VERSION \
    --platform linux/amd64 ./ebd-all-minilm
docker run --rm ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest pytest
docker run --rm --gpus all ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest pytest

docker system prune -f -a

# docker buildx build --push \
#     --cache-from=ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-cpu:latest \
#     --file ./mlg-diffusers/docker/cpu/Dockerfile \
#     --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" \
#     --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-cpu:latest \
#     --platform linux/arm64,linux/amd64 ./mlg-diffusers
# docker buildx build --push \
#     --cache-from=ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest \
#     --file ./mlg-diffusers/docker/cpu/Dockerfile \
#     --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-base" \
#     --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest \
#     --platform linux/arm64,linux/amd64 ./mlg-diffusers

# docker buildx build --push \
#     --cache-from=ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-gpu:latest \
#     --file ./mlg-diffusers/docker/gpu/Dockerfile \
#     --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" \
#     --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-1-base-gpu:latest \
#     --platform linux/amd64 ./mlg-diffusers
# docker buildx build --push \
#     --cache-from=ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-gpu:latest \
#     --file ./mlg-diffusers/docker/gpu/Dockerfile \
#     --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-base" \
#     --tag ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-gpu:latest \
#     --platform linux/amd64 ./mlg-diffusers

# docker run --rm ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-cpu:latest pytest
# docker run --rm --gpus all ghcr.io/premai-io/michelangelo-stable-diffusion-2-base-gpu:latest pytest

# docker buildx build --push \
#     --cache-from=ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
#     --file ./t2a-bark/docker/cpu/Dockerfile \
#     --tag ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
#     --platform linux/arm64,linux/amd64 ./t2a-bark
# docker buildx build --push \
#     --cache-from=ghcr.io/premai-io/text-to-audio-bark-gpu:latest \
#     --file ./t2a-bark/docker/gpu/Dockerfile \
#     --tag ghcr.io/premai-io/text-to-audio-bark-gpu:latest \
#     --platform linux/amd64 ./t2a-bark

# docker run --rm ghcr.io/premai-io/text-to-audio-bark-cpu:latest pytest
# docker run --rm --gpus all ghcr.io/premai-io/text-to-audio-bark-gpu:latest pytest
