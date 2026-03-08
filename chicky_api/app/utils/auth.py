from __future__ import annotations

from typing import Any

import httpx
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from ..config import get_settings

security = HTTPBearer()


async def verify_supabase_jwt(token: str) -> dict[str, Any]:
    """Verify a Supabase-issued JWT via the Supabase Auth REST API."""
    settings = get_settings()
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f"{settings.supabase_url}/auth/v1/user",
            headers={
                "apikey": settings.supabase_service_role_key,
                "Authorization": f"Bearer {token}",
            },
            timeout=10,
        )
    if resp.status_code != 200:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    user = resp.json()
    user.setdefault("sub", user.get("id"))
    return user


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> dict[str, Any]:
    """FastAPI dependency: returns the Supabase user object."""
    return await verify_supabase_jwt(credentials.credentials)


async def get_user_id(user: dict[str, Any] = Depends(get_current_user)) -> str:
    uid = user.get("sub") or user.get("id")
    if not uid:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User ID missing from token",
        )
    return uid
