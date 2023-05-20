echo "Building and testing whisper models"
docker buildx build --file ./prem-audio-to-text-wh/docker/gpu/Dockerfile --build-arg="MODEL_ID=large-v2" --build-arg="DEVICE=cuda" --tag prem-audio-to-text-wh ./prem-audio-to-text-wh
docker run --rm --gpus all --name prem-audio-to-text-wh prem-audio-to-text-wh pytest

exit

echo "Building and testing stable diffusion based models"
sudo docker buildx build --file ./prem-michelangelo-sd/docker/gpu/Dockerfile --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" --build-arg="DEVICE=cuda" --tag prem-michelangelo-sd ./prem-michelangelo-sd
sudo docker run --rm --gpus all --name prem-michelangelo-sd prem-michelangelo-sd pytest

echo "Building and testing sentence transformers based models"
sudo docker buildx build --file ./prem-embeddings-st/docker/gpu/Dockerfile --build-arg="MODEL_ID=sentence-transformers/all-MiniLM-L6-v2" --build-arg="DEVICE=cuda" --tag prem-embeddings-st ./prem-embeddings-st
sudo docker run --rm --gpus all --name prem-embeddings-st prem-embeddings-st pytest

echo "Building and testing dolly based models"
docker buildx build --file ./prem-chat-dolly-v2/docker/gpu/Dockerfile --build-arg="MODEL_ID=databricks/dolly-v2-12b" --build-arg="DEVICE=auto" --tag prem-chat-dolly-v2 ./prem-chat-dolly-v2
docker run --rm --gpus all --name prem-chat-dolly-v2 prem-chat-dolly-v2 pytest
