FROM python:3.10-slim-bullseye

RUN apt update && apt install -y libopenblas-dev ninja-build build-essential wget git
RUN python -m pip install --upgrade pip pytest cmake scikit-build setuptools

WORKDIR /usr/src/app/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip

COPY download.py .
ARG MODEL_ID
ENV MODEL_ID=$MODEL_ID
RUN python3 download.py --model $MODEL_ID

COPY . .
CMD python main.py
