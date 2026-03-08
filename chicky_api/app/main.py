from __future__ import annotations

from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import get_settings
from .database import create_pool, close_pool
from .routers import chat, scan, tts


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    settings = get_settings()
    if settings.database_url:
        app.state.db_pool = await create_pool()
    yield
    # Shutdown
    await close_pool()


def create_app() -> FastAPI:
    settings = get_settings()

    app = FastAPI(
        title=settings.api_title,
        version=settings.api_version,
        debug=settings.debug,
        lifespan=lifespan,
    )

    # CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Routers
    app.include_router(chat.router, prefix="/chat", tags=["chat"])
    app.include_router(scan.router, prefix="/scan", tags=["scan"])
    app.include_router(tts.router, prefix="/tts", tags=["tts"])

    @app.get("/health")
    async def health() -> dict:
        return {"status": "ok", "version": settings.api_version}

    return app


app = create_app()
