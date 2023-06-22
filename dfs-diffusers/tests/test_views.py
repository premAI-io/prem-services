from fastapi.testclient import TestClient
from main import get_application


def test_generate_image() -> None:
    app = get_application()
    with TestClient(app) as client:
        response = client.post(
            "/api/v1/images/generations",
            json={
                "prompt": "Hello World",
                "negative_prompt": "Goodbye World",
                "n": 4,
                "step_count": 25,
            },
        )
        assert response.status_code == 200
        print(response.json())
