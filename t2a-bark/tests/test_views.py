from fastapi.testclient import TestClient
from main import get_application


def test_text_to_audio() -> None:
    app = get_application()
    with TestClient(app) as client:
        response = client.post(
            "/api/v1/audio/generation",
            json={"prompt": "Hello World."},
        )
        assert response.status_code == 200
