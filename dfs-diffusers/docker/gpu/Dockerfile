FROM huggingface/transformers-pytorch-gpu:latest
WORKDIR /usr/src/app/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ARG MODEL_ID
ARG REFINER_ID
COPY download.py .
RUN python download.py --model $MODEL_ID --refiner "$REFINER_ID"

COPY . .
ENV MODEL_ID=$MODEL_ID
ENV REFINER_ID=$REFINER_ID
ENV DEVICE=cuda
CMD python main.py
