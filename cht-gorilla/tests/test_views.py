import os


from fastapi.testclient import TestClient
from main import get_application


def test_chat_gorilla() -> None:
    app = get_application()
    with TestClient(app) as client:
        response = client.post(
            "/v1/chat/completions",
            json={
                "model": os.getenv("MODEL_ID", "gorilla-llm/gorilla-falcon-7b-hf-v0"),
                "messages": [
                    {"role": "user", "content": "Generate an image of  a cat"}
                ],
            },
        )
        assert response.status_code == 200, response.content
