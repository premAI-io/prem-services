echo "Building and testing dolly based models"
docker buildx build --file ./prem-chat-dolly-v2/docker/gpu/Dockerfile --build-arg="MODEL_ID=dolly-v2-12b" --tag prem-chat-dolly-v2 ./prem-chat-dolly-v2
docker run -it --rm --gpus all --name prem-chat-dolly-v2-12b --env-file ./prem-chat-dolly-v2/.env prem-chat-dolly-v2 pytest
