FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 as build
WORKDIR /usr/src/app/

RUN apt update -qq && apt install -yqq --no-install-recommends \
    git python3 python3-dev python3-pip \
    && rm -rf /var/lib/apt/lists/*
RUN cd $(dirname $(which python3)) && ln -s python3 python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    jax[cuda]==0.3.25 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
WORKDIR /usr/src/app/

RUN apt update -qq && apt install -yqq --no-install-recommends \
    git python3 \
    && rm -rf /var/lib/apt/lists/*
RUN cd $(dirname $(which python3)) && ln -s python3 python
COPY --from=build --link /usr/local/lib/python3.10 /usr/local/lib/python3.10
COPY --from=build --link /usr/lib/python3.10 /usr/lib/python3.10
COPY --from=build --link /usr/lib/python3 /usr/lib/python3

ARG DALLE_MODEL_ID
ARG DALLE_REVISION_ID
ARG VQGAN_MODEL_ID
ARG VQGAN_REVISION_ID
COPY download.py .
RUN python download.py \
    --dalle-model $DALLE_MODEL_ID --dalle-revision $DALLE_REVISION_ID \
    --vqgan-model $VQGAN_MODEL_ID --vqgan-revision $VQGAN_REVISION_ID

COPY . .
ENV DALLE_MODEL_ID=$DALLE_MODEL_ID
ENV DALLE_REVISION_ID=$DALLE_REVISION_ID
ENV VQGAN_MODEL_ID=$VQGAN_MODEL_ID
ENV VQGAN_REVISION_ID=$VQGAN_REVISION_ID
ENV DEVICE=gpu
CMD python main.py
