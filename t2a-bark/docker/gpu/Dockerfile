FROM huggingface/transformers-pytorch-gpu:latest
WORKDIR /usr/src/app/

RUN cd $(dirname $(which python3)) && ln -s python3 python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ARG MODEL_ID
COPY download.py .
RUN python download.py

COPY . .
ENV MODEL_ID=$MODEL_ID
ENV DEVICE=cuda
CMD python main.py
