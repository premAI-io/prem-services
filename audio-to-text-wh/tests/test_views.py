from fastapi.testclient import TestClient
from main import get_application


def test_audio_to_text() -> None:
    app = get_application()
    with TestClient(app) as client:
        with open("./tests/audio.mp3", "rb") as file:
            response = client.post(
                "/api/v1/audio/transcriptions",
                files={"file": ("audio.mp3", file, "audio/mp3")},
                data={"model": "v2-large"},
            )
            assert response.status_code == 200
