import argparse
import logging
import os

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from models import SentenceTransformerBasedModel
from routes import router as api_router

load_dotenv()

MODEL_DIR = os.getenv("MODEL_ID", "all-MiniLM-L6-v2")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", help="Port to run model server on", type=int, default=8444)
    parser.add_argument("--model-dir", help="Path to model dir", default=MODEL_DIR)
    args = parser.parse_args()
    MODEL_DIR = args.model_dir

logging.basicConfig(
    format="%(asctime)s %(levelname)-8s %(message)s",
    level=logging.INFO,
    datefmt="%Y-%m-%d %H:%M:%S",
)


def create_start_app_handler(app: FastAPI):
    def start_app() -> None:
        SentenceTransformerBasedModel.get_model(MODEL_DIR)

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
    uvicorn.run("main:app", host="0.0.0.0", port=args.port)
