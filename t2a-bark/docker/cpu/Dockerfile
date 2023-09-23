FROM python:3.10-slim-bullseye
WORKDIR /usr/src/app/

RUN apt update -qq && apt install -yqq --no-install-recommends \
    build-essential git wget libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ARG MODEL_ID
COPY download.py .
RUN python download.py

COPY . .
ENV MODEL_ID=$MODEL_ID
ENV DEVICE=cpu
ENV SUNO_OFFLOAD_CPU=True
ENV SUNO_USE_SMALL_MODELS=True
CMD python main.py
