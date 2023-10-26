import json

from fastapi.testclient import TestClient
from main import PROMPT_TEMPLATE_STRING, get_application
from models import LLaMACPPBasedModel


def test_chat_llama_cpp() -> None:
    app = get_application()
    with TestClient(app) as client:
        response = client.post(
            "/v1/chat/completions",
            json={
                "model": "vicuna-7b-q4",
                "messages": [{"role": "user", "content": "Hello!"}],
                "n_threads": 10,
            },
        )
        assert response.status_code == 200

        response = client.post(
            "/v1/chat/completions",
            json={
                "stream": True,
                "model": "vicuna-7b-q4",
                "messages": [{"role": "user", "content": "Hello!"}],
            },
        )
        assert response.status_code == 200


def test_chatml_stitch_prompt():
    messages = [
        {"role": "user", "content": "Why should we run ML models on premise?"},
        {
            "role": "assistant",
            "content": "There are several reasons why an organization might choose to run machine learning (ML) models on-premise:\n\n1. Security and privacy concerns: Running ML models on-premise allows organizations to",  # noqa
        },
    ]
    prompt_template = json.loads(PROMPT_TEMPLATE_STRING)
    assert prompt_template["template_format"] == "chatml"
    result = LLaMACPPBasedModel.stitch_prompt(messages, prompt_template=prompt_template)
    assert (
        result
        == """<|im_start|>system
You are an helpful AI assistant.
<|im_end|>
<|im_start|>user
Why should we run ML models on premise?
<|im_end|>
<|im_start|>assistant
There are several reasons why an organization might choose to run machine learning (ML) models on-premise:

1. Security and privacy concerns: Running ML models on-premise allows organizations to
<|im_end|>
<|im_start|>assistant
"""
    )
