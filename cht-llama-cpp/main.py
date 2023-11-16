import argparse
import logging
import os

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import router as api_router

load_dotenv()

MODEL_PATH = f"./ml/models/{os.getenv('MODEL_ID', 'yarn-mistral-7b-128k.Q4_K_M')}.gguf"
# Mistral gguf follows ChatML syntax
# https://github.com/openai/openai-python/blob/main/chatml.md
PROMPT_TEMPLATE_STRING = '{"system_prompt_template": "<|im_start|>system\\n{}\\n<|im_end|>\\n", "default_system_text": "You are an helpful AI assistant.", "user_prompt_template": "<|im_start|>user\\n{}\\n<|im_end|>\\n", "assistant_prompt_template": "<|im_start|>assistant\\n{}\\n<|im_end|>\\n", "request_assistant_response_token": "<|im_start|>assistant\\n", "template_format": "chatml"}'  # noqa
MODEL_CTX = 4096
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model-path", help="Path to GGUF", default=MODEL_PATH)
    parser.add_argument("--port", help="Port to run model server on", type=int, default=8000)
    parser.add_argument("--ctx", help="Context dimension", type=int, default=MODEL_CTX)
    parser.add_argument(
        "--prompt_template",
        help="Prompt Template",
        type=str,
        default=PROMPT_TEMPLATE_STRING,  # noqa
    )  # noqa
    args = parser.parse_args()
    MODEL_PATH = args.model_path
    MODEL_CTX = args.ctx
    PROMPT_TEMPLATE_STRING = args.prompt_template

logging.basicConfig(
    format="%(asctime)s %(levelname)-8s %(message)s",
    level=logging.INFO,
    datefmt="%Y-%m-%d %H:%M:%S",
)


def create_start_app_handler(app: FastAPI):
    def start_app() -> None:
        from models import LLaMACPPBasedModel

        LLaMACPPBasedModel.get_model(MODEL_PATH, PROMPT_TEMPLATE_STRING, MODEL_CTX)

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
