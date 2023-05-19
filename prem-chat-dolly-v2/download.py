from transformers import AutoModel, AutoTokenizer

model_name = "databricks/dolly-v2-12b"

model = AutoModel.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)
