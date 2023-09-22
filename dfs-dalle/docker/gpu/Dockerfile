FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04
WORKDIR /usr/src/app/

RUN apt update -qq && apt install -yqq --no-install-recommends \
    git python python-pip \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install jax[cuda11_cudnn82]==0.3.25 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
RUN pip install --no-cache-dir -r requirements.txt

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
