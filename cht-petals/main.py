import argparse
import logging
import os

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import router as api_router

load_dotenv()

MODEL_ID = os.getenv("MODEL_ID", "petals-team/StableBeluga2")
MODEL_PATH = os.getenv("MODEL_PATH", "models")
DHT_PREFIX = os.getenv("DHT_PREFIX", "StableBeluga2-hf")
PROMPT_TEMPLATE_STRING = '{"system_prompt_template": "### System:\\n{}\\n", "default_system_text": "You are an helpful AI assistant created by StabilityAI.", "user_prompt_template": "\\n### User:\\n{}\\n", "assistant_prompt_template": "\\n### Assistant:\\n{}\\n", "request_assistant_response_token": "\\n### Assistant:\\n", "template_format": "stablebeluga2"}'  # noqa
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model-id", help="HuggingFace Model", default=MODEL_ID)
    parser.add_argument("--model-path", help="Path to Model files directory", default=MODEL_PATH)
    parser.add_argument("--dht-prefix", help="DHT prefix to use", default=DHT_PREFIX)
    parser.add_argument("--port", help="Port to run model server on", type=int, default=8000)
    args = parser.parse_args()
    MODEL_PATH = args.model_path
    DHT_PREFIX = args.dht_prefix

logging.basicConfig(
    format="%(asctime)s %(levelname)-8s %(message)s",
    level=logging.INFO,
    datefmt="%Y-%m-%d %H:%M:%S",
)


def create_start_app_handler(app: FastAPI):
    def start_app() -> None:
        from models import PetalsBasedModel

        print(f"Using {MODEL_PATH=} and {DHT_PREFIX=}")
        PetalsBasedModel.get_model(MODEL_PATH, DHT_PREFIX, prompt_template_jsonstr=PROMPT_TEMPLATE_STRING)

    return start_app


def get_application() -> FastAPI:
    application = FastAPI(title="prem-chat", debug=True, version="0.0.1")
    application.include_router(api_router, prefix="/v1")
    application.add_event_handler("startup", create_start_app_handler(application))
    application.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    return application


app = get_application()

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=args.port)
