export VERSION=0.0.2

docker system prune -f -a

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
    --cache-from ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest \
    --file ./ebd-all-minilm/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=all-MiniLM-L6-v2" \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest \
    --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:$VERSION \
    --platform linux/amd64 ./ebd-all-minilm
docker run --rm ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest pytest
docker run --rm --gpus all ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest pytest

docker system prune -f -a

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/text-to-audio-bark-gpu:latest \
    --file ./t2a-bark/docker/gpu/Dockerfile \
    --tag ghcr.io/premai-io/text-to-audio-bark-gpu:latest \
    --tag ghcr.io/premai-io/text-to-audio-bark-gpu:$VERSION \
    --platform linux/amd64 ./t2a-bark

docker run --rm --gpus all ghcr.io/premai-io/text-to-audio-bark-gpu:latest pytest
