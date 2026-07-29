import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    GEOAPIFY_API_KEY: str = os.getenv("GEOAPIFY_API_KEY", "")
    OLLAMA_BASE_URL: str = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
    OLLAMA_MODEL: str = os.getenv("OLLAMA_MODEL", "gemma2:9b")
    PORT: int = int(os.getenv("PORT", "8000"))

settings = Settings()