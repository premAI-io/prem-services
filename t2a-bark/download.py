from bark import preload_models
from tenacity import retry, stop_after_attempt, wait_fixed

print("Downloading model")


@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def download_model():
    preload_models()


download_model()
