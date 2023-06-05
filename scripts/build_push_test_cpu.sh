export VERSION=0.0.2

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
docker run --rm --gpus all ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest pytest

docker system prune -f -a
