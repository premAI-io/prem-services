docker buildx build --file ./copilot-replit/docker/gpu/Dockerfile --build-arg="MODEL_ID=replit/replit-code-v1-3b" --tag ghcr.io/premai-io/copilot-replit-code-v1-3b-gpu:latest --platform linux/arm64,linux/amd64 ./copilot-replit
docker run --rm --gpus all ghcr.io/premai-io/copilot-replit-code-v1-3b-gpu:latest pytest
docker push ghcr.io/premai-io/copilot-replit-code-v1-3b-gpu:latest
