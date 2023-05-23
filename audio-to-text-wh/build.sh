docker buildx build --file ./audio-to-text-wh/docker/cpu/Dockerfile --build-arg="MODEL_ID=tiny" --tag ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest --platform linux/arm64,linux/amd64 ./audio-to-text-wh
docker buildx build --file ./audio-to-text-wh/docker/gpu/Dockerfile --build-arg="MODEL_ID=large-v2" --tag ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest --platform linux/arm64,linux/amd64 ./audio-to-text-wh

docker run --rm ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest pytest
docker run --rm ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest pytest

docker push ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu:latest
docker push ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu:latest
