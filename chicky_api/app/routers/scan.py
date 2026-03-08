"""Scan router — word lookup endpoint."""
from __future__ import annotations

from typing import Any

from fastapi import APIRouter, Depends, HTTPException, status

from ..models.scan_models import WordLookupRequest, WordLookupResponse
from ..services.dictionary_service import get_dictionary_service
from ..utils.auth import get_current_user

router = APIRouter()


@router.post("/lookup", response_model=WordLookupResponse)
async def lookup_word(
    request: WordLookupRequest,
    user: dict[str, Any] = Depends(get_current_user),
) -> WordLookupResponse:
    """Look up a word's definition, IPA, and examples.

    First checks the Free Dictionary API. Returns 404 if not found.
    """
    dictionary = get_dictionary_service()
    result = await dictionary.lookup(request.word.lower().strip())

    if result is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Word '{request.word}' not found in dictionary",
        )

    return result
