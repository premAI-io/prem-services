FROM python:3.10-slim-bullseye
WORKDIR /usr/src/app/

RUN apt update -qq && apt install -yqq --no-install-recommends \
    libopenblas-dev ninja-build build-essential wget git \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
#RUN pip install pytest cmake scikit-build setuptools
RUN pip install --no-cache-dir -r requirements.txt

ARG MODEL_ID
COPY download.py .
RUN python download.py --model $MODEL_ID

COPY . .
ENV MODEL_ID=$MODEL_ID
CMD python main.py
