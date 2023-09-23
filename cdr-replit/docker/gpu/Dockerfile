FROM huggingface/transformers-pytorch-gpu:4.28.1
WORKDIR /usr/src/app/

RUN cd $(dirname $(which python3)) && ln -s python3 python
COPY requirements.txt .
RUN pip install "accelerate>=0.16.0,<1"
RUN pip install --no-cache-dir -r requirements.txt

ARG MODEL_ID
COPY download.py .
RUN python download.py --model $MODEL_ID

COPY . .
ENV MODEL_ID=$MODEL_ID
CMD python main.py
