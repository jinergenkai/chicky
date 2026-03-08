from functools import lru_cache
from typing import Literal

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # Supabase
    supabase_url: str = ""
    supabase_service_role_key: str = ""
    supabase_jwt_secret: str = ""

    # Database (direct asyncpg)
    database_url: str = ""  # postgres://user:pass@host:5432/db

    # LLM
    llm_provider: Literal["openai", "anthropic"] = "openai"
    openai_api_key: str = ""
    anthropic_api_key: str = ""
    openai_model: str = "gpt-4o-mini"
    anthropic_model: str = "claude-3-5-haiku-20241022"

    # OpenAI Whisper
    whisper_model: str = "whisper-1"

    # TTS
    tts_voice: str = "en-US-JennyNeural"
    tts_rate: str = "+0%"
    tts_pitch: str = "+0Hz"

    # App
    cors_origins: list[str] = ["*"]
    debug: bool = False
    api_title: str = "Chicky API"
    api_version: str = "1.0.0"


@lru_cache
def get_settings() -> Settings:
    return Settings()
