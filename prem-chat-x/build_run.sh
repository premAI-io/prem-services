docker buildx build --file ./prem-chat-x/docker/llamacpp/cpu/Dockerfile --build-arg="MODEL_ID=vicuna-7b-q4" --tag ghcr.io/premai-io/prem-chat-vicuna-7b-q4-cpu:latest ./prem-chat-x
docker run -it --rm --name prem-chat-vicuna-7b-q4-cpu --env-file ./prem-chat-x/.env ghcr.io/premai-io/prem-chat-vicuna-7b-q4-cpu:latest
