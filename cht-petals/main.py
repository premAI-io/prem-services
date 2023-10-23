import argparse
import logging
import os

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import router as api_router

load_dotenv()

MODEL_PATH = os.getenv("MODEL_PATH", "./models")
DHT_PREFIX = os.getenv("DHT_PREFIX", "StableBeluga2")
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model-path", help="Path to Model files directory", default=MODEL_PATH)
    parser.add_argument("--dht-prefix", help="DHT prefix to use")
    parser.add_argument("--port", help="Port to run model server on", type=int)
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
        PetalsBasedModel.get_model(MODEL_PATH, DHT_PREFIX)

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
