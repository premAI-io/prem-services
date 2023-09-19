from fastapi.testclient import TestClient
from main import get_application


def test_chat_llama_cpp() -> None:
    app = get_application()
    with TestClient(app) as client:
        response = client.post(
            "/v1/chat/completions",
            json={
                "model": "stable-beluga",
                "messages": [{"role": "user", "content": "Hello!"}],
                "n_threads": 10,
            },
        )
        assert response.status_code == 200

        response = client.post(
            "/v1/chat/completions",
            json={
                "stream": True,
                "model": "stable-beluga",
                "messages": [{"role": "user", "content": "Hello!"}],
            },
        )
        assert response.status_code == 200
