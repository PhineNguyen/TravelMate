import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    GEOAPIFY_API_KEY: str = os.getenv("GEOAPIFY_API_KEY", "")
    GROQ_API_KEY: str = os.getenv("GROQ_API_KEY", "")
    GROQ_MODEL: str = os.getenv("GROQ_MODEL", "openai/gpt-oss-20b")
    PORT: int = int(os.getenv("PORT", "8001"))
    DB_HOST: str = os.getenv("DB_HOST", "localhost")
    DB_PORT: int = int(os.getenv("DB_PORT", "5435"))
    DB_NAME: str = os.getenv("DB_NAME", "ai_service_gpt_chat")
    DB_USER: str = os.getenv("DB_USER", "ai_user")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD", "ai_password")

settings = Settings()
