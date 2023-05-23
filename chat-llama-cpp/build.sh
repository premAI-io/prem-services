docker buildx build --file ./chat-llama-cpp/docker/cpu/Dockerfile --build-arg="MODEL_ID=vicuna-7b-q4" --tag ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest --platform linux/arm64,linux/amd64 ./chat-llama-cpp
docker buildx build --file ./chat-llama-cpp/docker/cpu/Dockerfile --build-arg="MODEL_ID=gpt4all-lora-q4" --tag ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:latest --platform linux/arm64,linux/amd64 ./chat-llama-cpp
docker run --rm ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest pytest
docker push ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest
docker push ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:latest
