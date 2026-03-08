from __future__ import annotations

from typing import Any

import httpx
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt

from ..config import get_settings

security = HTTPBearer()


def verify_supabase_jwt(token: str) -> dict[str, Any]:
    """Verify a Supabase-issued JWT and return the decoded payload."""
    settings = get_settings()
    try:
        payload = jwt.decode(
            token,
            settings.supabase_jwt_secret,
            algorithms=["HS256"],
            audience="authenticated",
        )
        return payload
    except JWTError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid authentication credentials: {exc}",
            headers={"WWW-Authenticate": "Bearer"},
        )


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> dict[str, Any]:
    """FastAPI dependency: returns the decoded JWT payload."""
    return verify_supabase_jwt(credentials.credentials)


def get_user_id(user: dict[str, Any] = Depends(get_current_user)) -> str:
    uid = user.get("sub")
    if not uid:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User ID missing from token",
        )
    return uid
