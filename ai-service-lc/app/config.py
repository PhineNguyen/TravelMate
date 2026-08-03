import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    GEOAPIFY_API_KEY: str = os.getenv("GEOAPIFY_API_KEY", "")
    OLLAMA_BASE_URL: str = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
    OLLAMA_MODEL: str = os.getenv("OLLAMA_MODEL", "gemma2:9b")
    PORT: int = int(os.getenv("PORT", "8000"))
    DB_HOST: str = os.getenv("DB_HOST", "localhost")
    DB_PORT: int = int(os.getenv("DB_PORT", "5433"))
    DB_NAME: str = os.getenv("DB_NAME", "ai_service_chat")
    DB_USER: str = os.getenv("DB_USER", "postgres")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD", "21052026")

settings = Settings()