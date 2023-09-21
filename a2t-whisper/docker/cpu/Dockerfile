FROM python:3.10-slim-bullseye

WORKDIR /usr/src/app/

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    libatlas-base-dev \
    ffmpeg
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

ARG MODEL_ID
COPY download.py .
RUN python3 download.py --model $MODEL_ID

COPY . .
ENV MODEL_ID=$MODEL_ID
ENV DEVICE=cpu
CMD python3 main.py
