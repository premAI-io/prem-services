echo "Building and testing replit based models"
docker buildx build --file ./copilot-replit/docker/gpu/Dockerfile --build-arg="MODEL_ID=replit/replit-code-v1-3b" --tag copilot-replit2 ./copilot-replit
docker run --rm --gpus all --name copilot-replit copilot-replit pytest

echo "Building and testing bark models"
docker buildx build --file ./text-to-audio-ba/docker/gpu/Dockerfile --tag text-to-audio-ba ./text-to-audio-ba
docker run --rm --gpus all --name text-to-audio-ba text-to-audio-ba pytest

echo "Building and testing whisper models"
docker buildx build --file ./audio-to-text-wh/docker/gpu/Dockerfile --build-arg="MODEL_ID=large-v2" --tag audio-to-text-wh ./audio-to-text-wh
docker run --rm --gpus all --name audio-to-text-wh audio-to-text-wh pytest

echo "Building and testing stable diffusion based models"
sudo docker buildx build --file ./michelangelo-sd/docker/gpu/Dockerfile --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" --tag michelangelo-sd ./michelangelo-sd
sudo docker run --rm --gpus all --name michelangelo-sd michelangelo-sd pytest

echo "Building and testing sentence transformers based models"
sudo docker buildx build --file ./embeddings-st/docker/gpu/Dockerfile --build-arg="MODEL_ID=sentence-transformers/all-MiniLM-L6-v2" --tag embeddings-st ./embeddings-st
sudo docker run --rm --gpus all --name embeddings-st embeddings-st pytest

echo "Building and testing dolly based models"
docker buildx build --file ./chat-dolly-v2/docker/gpu/Dockerfile --build-arg="MODEL_ID=databricks/dolly-v2-12b" --tag chat-dolly-v2 ./chat-dolly-v2
docker run --rm --gpus all --name chat-dolly-v2 chat-dolly-v2 pytest
