FROM python:3.10-slim-bullseye
WORKDIR /usr/src/app/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ARG MODEL_ID
COPY download.py .
RUN python3 download.py --model $MODEL_ID

COPY . .
ENV MODEL_ID=$MODEL_ID
ENV DEVICE=cpu
CMD python main.py
