from fastapi.testclient import TestClient
from main import get_application


def test_compute_embeddings() -> None:
    app = get_application()
    with TestClient(app) as client:
        response = client.post(
            "/api/v1/embeddings",
            json={
                "model": "all-MiniLM-L6-v2",
                "input": "Hello!",
            },
        )
        assert response.status_code == 200
