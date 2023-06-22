export VERSION=0.0.5

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
    --cache-from ghcr.io/premai-io/coder-codet5p-220m-py-cpu:latest \
    --file ./cdr-t5/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" \
    --tag ghcr.io/premai-io/coder-codet5p-220m-py-cpu:latest \
    --tag ghcr.io/premai-io/coder-codet5p-220m-py-cpu:$VERSION \
    --platform linux/amd64 ./cdr-t5

docker run --rm ghcr.io/premai-io/coder-codet5p-220m-py-cpu:latest pytest

docker buildx create --use
docker buildx build --push \
    --cache-from=ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
    --file ./t2a-bark/docker/cpu/Dockerfile \
    --tag ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
    --tag ghcr.io/premai-io/text-to-audio-bark-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./t2a-bark

docker run --rm ghcr.io/premai-io/text-to-audio-bark-cpu:latest pytest
