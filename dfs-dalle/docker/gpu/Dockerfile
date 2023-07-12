FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

RUN apt-get update && apt-get install -y \
  git \
  python3 \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*


ARG DALLE_MODEL_ID
ARG DALLE_REVISION_ID

ARG VQGAN_MODEL_ID
ARG VQGAN_REVISION_ID

WORKDIR /usr/src/app/

COPY requirements.txt /usr/src/app/

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install jax[cuda11_cudnn82]==0.3.25 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

COPY download.py .

RUN python3 download.py --dalle-model $DALLE_MODEL_ID --dalle-revision $DALLE_REVISION_ID \
    --vqgan-model $VQGAN_MODEL_ID --vqgan-revision $VQGAN_REVISION_ID

COPY . .

ENV DALLE_MODEL_ID=$DALLE_MODEL_ID
ENV DALLE_REVISION_ID=$DALLE_REVISION_ID
ENV VQGAN_MODEL_ID=$VQGAN_MODEL_ID
ENV VQGAN_REVISION_ID=$VQGAN_REVISION_ID

ENV DEVICE=gpu

CMD python3 main.py
