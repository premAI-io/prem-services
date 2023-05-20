echo "Building and testing sentence transformers based models"
sudo docker buildx build --file ./prem-embeddings-st/docker/gpu/Dockerfile --build-arg="MODEL_ID=all-MiniLM-L6-v2" --tag prem-embeddings-st ./prem-embeddings-st
sudo docker run --rm --gpus all --name prem-embeddings-st prem-embeddings-st pytest

echo "Building and testing dolly based models"
docker buildx build --file ./prem-chat-dolly-v2/docker/gpu/Dockerfile --build-arg="MODEL_ID=dolly-v2-12b" --tag prem-chat-dolly-v2 ./prem-chat-dolly-v2
docker run --rm --gpus all --name prem-chat-dolly-v2 prem-chat-dolly-v2 pytest
