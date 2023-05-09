import logging

from fastapi import FastAPI
from utils import load_model

logger = logging.getLogger(__name__)


def create_start_app_handler(app: FastAPI):
    def start_app() -> None:
        load_model()

    return start_app
