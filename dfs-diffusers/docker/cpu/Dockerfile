FROM python:3.10-slim-bullseye

ARG MODEL_ID

WORKDIR /usr/src/app/

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    libatlas-base-dev

COPY requirements.txt /usr/src/app/

RUN pip3 install transformers==4.29.2 accelerate==0.19.0 torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2
RUN pip3 install --no-cache-dir -r requirements.txt

COPY download.py .

RUN python3 download.py --model $MODEL_ID

COPY . .

ENV MODEL_ID=$MODEL_ID
ENV DEVICE=cpu

CMD python3 main.py
