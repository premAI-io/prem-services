from fastapi.testclient import TestClient
from main import get_application


def test_code_gen_t5() -> None:
    app = get_application()
    with TestClient(app) as client:
        response = client.post(
            "/v1/engines/codegen/completions",
            json={
                "prompt": "def print_hello_world():",
            },
        )
        assert response.status_code == 200
