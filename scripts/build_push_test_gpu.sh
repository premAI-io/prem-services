export VERSION=0.0.2

docker system prune -f -a

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/text-to-audio-bark-gpu:latest \
    --file ./t2a-bark/docker/gpu/Dockerfile \
    --tag ghcr.io/premai-io/text-to-audio-bark-gpu:latest \
    --tag ghcr.io/premai-io/text-to-audio-bark-gpu:$VERSION \
    --platform linux/amd64 ./t2a-bark

docker run --rm --gpus all ghcr.io/premai-io/text-to-audio-bark-gpu:latest pytest
