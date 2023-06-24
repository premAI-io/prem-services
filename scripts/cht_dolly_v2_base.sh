docker buildx build --push \
    --file ./cht-dolly-v2/docker/gpu/base.Dockerfile \
    --build-arg="MODEL_ID=databricks/dolly-v2-12b" \
    --tag ghcr.io/premai-io/chat-dolly-v2-12b-gpu-base:latest \
    ./cht-dolly-v2
