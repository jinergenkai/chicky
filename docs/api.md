# API Contracts

Base URL: `http://your-server:8000/api/v1`

---

## FastAPI Endpoints

### Chat — Text Mode

```
POST /chat/text
Authorization: Bearer <supabase_jwt>

Request:
{
  "message": "Yesterday I go to bank and ask about mortgage",
  "session_id": "uuid-session",  // null to create new session
  "mode": "buddy"  // "buddy" | "role_play"
}

Response:
{
  "session_id": "uuid-session",
  "reply": "Oh you went to the bank yesterday and asked about a mortgage? ...",
  "corrections": [...],
  "vocab_used": ["mortgage"],
  "vocab_ids": ["uuid-word"]
}
```

### Chat — Voice Mode (WebSocket)

```
WS /chat/voice
Authorization: via query param ?token=<supabase_jwt>

Flow:
1. Client sends: {"type": "start", "session_id": "uuid", "mode": "buddy"}
2. Client sends: binary audio data (WAV/PCM chunks)
3. Client sends: {"type": "end"}  // recording finished
4. Server sends: {"type": "transcript", "text": "Yesterday I go..."}
5. Server sends: {"type": "corrections", "data": [...]}
6. Server sends: binary audio chunks (TTS response, sentence by sentence)
7. Server sends: {"type": "done", "reply_text": "full response", "vocab_used": [...]}
```

### Scan — Word Lookup

```
POST /scan/lookup
Authorization: Bearer <supabase_jwt>

Request:
{
  "word": "collateralized"
}

Response:
{
  "id": "uuid-word",
  "word": "collateralized",
  "ipa": "/kəˈlætərəlaɪzd/",
  "definitions": [{"pos": "verb", "en": "to pledge assets as security", "vi": null}],
  "frequency_rank": 12500,
  "verified": false,
  "created_by": "auto_scan"
}
```

### TTS — Text to Speech

```
POST /tts

Request:
{
  "text": "Oh you went to the bank yesterday?",
  "voice": "en-US-AriaNeural"  // Edge TTS voice
}

Response: audio/mpeg binary stream
```
