echo "Building and testing llama_cpp based models"
docker buildx build --file ./prem-chat-x/docker/llamacpp/m1/Dockerfile --build-arg="MODEL_ID=vicuna-7b-q4" --tag prem-chat-llama-cpp-test ./prem-chat-x
docker run -it --rm --name prem-chat-vicuna-7b-q4-m1 --env-file ./prem-chat-x/.env prem-chat-llama-cpp-test pytest
