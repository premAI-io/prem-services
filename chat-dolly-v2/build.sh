docker buildx build --file ./chat-dolly-v2/docker/gpu/Dockerfile --build-arg="MODEL_ID=databricks/dolly-v2-12b" --tag ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest --platform linux/arm64,linux/amd64 ./chat-dolly-v2
docker run --rm --gpus all ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest pytest
docker push ghcr.io/premai-io/chat-dolly-v2-12b-gpu:latest
