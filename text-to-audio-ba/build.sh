docker buildx build --file ./text-to-audio-ba/docker/cpu/Dockerfile --tag ghcr.io/premai-io/text-to-audio-bark-cpu:latest --platform linux/arm64,linux/amd64 ./text-to-audio-ba
docker buildx build --file ./text-to-audio-ba/docker/gpu/Dockerfile --tag ghcr.io/premai-io/text-to-audio-bark-gpu:latest --platform linux/arm64,linux/amd64 ./text-to-audio-ba

docker run --rm ghcr.io/premai-io/text-to-audio-bark-cpu:latest pytest
docker run --rm --gpus all ghcr.io/premai-io/text-to-audio-bark-gpu:latest pytest

docker push ghcr.io/premai-io/text-to-audio-bark-cpu:latest
docker push ghcr.io/premai-io/text-to-audio-bark-gpu:latest
