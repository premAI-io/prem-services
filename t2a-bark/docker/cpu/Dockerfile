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

RUN pip3 install --no-cache-dir -r requirements.txt

COPY download.py .

RUN python3 download.py

COPY . .

ENV MODEL_ID=$MODEL_ID
ENV DEVICE=cpu
ENV SUNO_OFFLOAD_CPU=True
ENV SUNO_USE_SMALL_MODELS=True

CMD python3 main.py
