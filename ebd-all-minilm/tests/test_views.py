from fastapi.testclient import TestClient
from main import get_application


def test_compute_embeddings() -> None:
    app = get_application()
    with TestClient(app) as client:
        response = client.post(
            "/api/v1/engines/text-embedding-ada-002/embeddings",
            json={
                "model": "all-MiniLM-L6-v2",
                "input": [
                    [
                        42562.0,
                        374.0,
                        459.0,
                        4228.0,
                        311.0,
                        1005.0,
                        1825.0,
                        2592.0,
                        15592.0,
                        5452.0,
                        13.0,
                    ]
                ],
            },
        )
        assert response.status_code == 200

        response = client.post(
            "/api/v1/engines/text-embedding-ada-002/embeddings",
            json={
                "model": "all-MiniLM-L6-v2",
                "input": ["Hello!"],
            },
        )
        assert response.status_code == 200
