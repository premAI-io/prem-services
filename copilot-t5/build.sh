docker buildx build --file ./copilot-t5/docker/cpu/Dockerfile --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" --tag ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest --platform linux/arm64,linux/amd64 ./copilot-t5
docker run --rm ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest pytest
docker push ghcr.io/premai-io/copilot-codet5p-220m-py-cpu:latest
