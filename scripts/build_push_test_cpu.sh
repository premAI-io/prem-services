export VERSION=0.0.5

docker buildx create --use
docker buildx build --push \
    --cache-from=ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
    --file ./t2a-bark/docker/cpu/Dockerfile \
    --tag ghcr.io/premai-io/text-to-audio-bark-cpu:latest \
    --tag ghcr.io/premai-io/text-to-audio-bark-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./t2a-bark

docker run --rm ghcr.io/premai-io/text-to-audio-bark-cpu:latest pytest
