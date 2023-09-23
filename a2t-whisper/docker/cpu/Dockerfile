FROM python:3.10-slim-bullseye
WORKDIR /usr/src/app/

RUN apt update -qq && apt install -yqq --no-install-recommends \
    build-essential git wget libatlas-base-dev ffmpeg \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ARG MODEL_ID
COPY download.py .
RUN python download.py --model $MODEL_ID

COPY . .
ENV MODEL_ID=$MODEL_ID
ENV DEVICE=cpu
CMD python main.py
