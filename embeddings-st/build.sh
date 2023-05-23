docker buildx build --file ./embeddings-st/docker/cpu/Dockerfile --build-arg="MODEL_ID=sentence-transformers/all-MiniLM-L6-v2" --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest --platform linux/arm64,linux/amd64 ./embeddings-st
docker buildx build --file ./embeddings-st/docker/gpu/Dockerfile --build-arg="MODEL_ID=sentence-transformers/all-MiniLM-L6-v2" --tag ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest --platform linux/arm64,linux/amd64 ./embeddings-st

docker run --rm ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest pytest
docker run --rm --gpus all ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest pytest

docker push ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu:latest
docker push ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu:latest
