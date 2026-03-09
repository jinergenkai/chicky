# Architecture & Tech Stack

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                     Flutter App                          │
│  ┌──────────┐  ┌──────────┐  ┌────────────────────┐    │
│  │ VocMap   │  │  Scan    │  │  Buddy Chat        │    │
│  │ (Cards)  │  │  Text    │  │  (Voice + Text)    │    │
│  └────┬─────┘  └────┬─────┘  └────────┬───────────┘    │
│       │              │                  │                 │
│  ┌────┴──────────────┴──────┐  ┌───────┴──────────┐    │
│  │   Supabase Flutter SDK   │  │   Dio / WebSocket │    │
│  └────────────┬─────────────┘  └───────┬──────────┘    │
│               │                         │                │
│  ┌────────────┴─────────┐              │                │
│  │  Hive (Local Cache)  │              │                │
│  └──────────────────────┘              │                │
└───────────────┬────────────────────────┤────────────────┘
                │                        │
                ▼                        ▼
┌───────────────────────────┐  ┌─────────────────────────┐
│      Supabase (Managed)   │  │   FastAPI (AI Service)  │
│  ┌─────────────────────┐  │  │                         │
│  │  Auth (OAuth/Email)  │  │  │  POST /chat/voice      │
│  ├─────────────────────┤  │  │  POST /chat/text       │
│  │  PostgreSQL          │  │  │  POST /tts             │
│  │  ├── words           │  │  │  POST /scan/process    │
│  │  ├── word_relations  │  │  │                         │
│  │  ├── domains         │  │  │  Integrations:          │
│  │  ├── domain_words    │  │  │  ├── Whisper API (STT) │
│  │  ├── user_vocabulary │  │  │  ├── LLM (configurable)│
│  │  ├── chat_sessions   │  │  │  ├── Edge TTS (free)   │
│  │  ├── chat_messages   │  │  │  └── Free Dict API     │
│  │  └── scan_sessions   │  │  │                         │
│  ├─────────────────────┤  │  │  Connects to Supabase   │
│  │  Edge Functions      │  │  │  PostgreSQL via asyncpg │
│  │  (simple helpers)    │  │  │                         │
│  └─────────────────────┘  │  └─────────────────────────┘
└───────────────────────────┘
```

## Key Architecture Decisions

| Decision          | Choice                       | Rationale                                                            |
| ----------------- | ---------------------------- | -------------------------------------------------------------------- |
| Data layer        | Supabase (Auth + PostgreSQL) | Managed, free tier 50K MAU, relational data fits vocab graph         |
| AI service        | FastAPI (Python)             | Native AI ecosystem (Whisper, edge-tts, Wordfreq, FSRS), lightweight |
| Mobile framework  | Flutter                      | Cross-platform iOS/Android, Picovoice SDK support, prior experience  |
| State management  | Riverpod                     | Clean, testable, scalable, Flutter community recommended             |
| Spaced repetition | FSRS                         | Newer than SM-2, Anki migrating to it, better retention curves       |
| DB migrations     | Supabase CLI migrations      | Raw SQL, simple, no ORM overhead                                     |
| Local cache       | Hive                         | Offline vocab access, fast key-value store for Flutter               |
| Voice wakeword    | Picovoice                    | On-device, offline, custom wakeword "Hey Chicky", tested             |

## Separation of Concerns

- **Supabase** handles ONLY: auth, data storage, user management.
- **FastAPI** handles ONLY: AI processing (STT, LLM, TTS), external API calls.
- **Flutter** handles ONLY: UI, local cache, wakeword detection, audio recording/playback.
- **Fault isolation:** Supabase down → chat still works from cache. FastAPI down → VocMap/Scan still work. Neither takes the other down.

---

## Tech Stack

### Flutter App

```yaml
dependencies:
  # Core
  flutter_riverpod: ^2.x # State management
  supabase_flutter: ^2.x # Auth + DB (single SDK)

  # HTTP & Networking
  dio: ^5.x # HTTP client for FastAPI
  web_socket_channel: ^2.x # WebSocket for voice streaming

  # Voice
  picovoice_flutter: ^3.x # Wakeword "Hey Chicky" (offline)
  record: ^5.x # Audio recording from mic
  just_audio: ^0.9.x # Play TTS audio responses

  # UI
  flutter_card_swiper: ^7.x # Swipe cards for VocMap
  shimmer: ^3.x # Loading skeletons

  # Data
  hive_flutter: ^1.x # Local cache (offline vocab)
  json_annotation: ^4.x # JSON serialization
  freezed_annotation: ^2.x # Immutable data models

  # Utils
  go_router: ^14.x # Navigation

dev_dependencies:
  build_runner: ^2.x
  freezed: ^2.x
  json_serializable: ^6.x
  hive_generator: ^2.x
  riverpod_generator: ^2.x
```

### FastAPI (AI Service)

```txt
# requirements.txt
fastapi>=0.110.0
uvicorn>=0.27.0
asyncpg>=0.29.0          # PostgreSQL async driver
websockets>=12.0          # WebSocket support
httpx>=0.27.0             # Async HTTP client

# AI / NLP
openai>=1.12.0            # Whisper API + optional GPT
anthropic>=0.18.0         # Claude API (optional)
edge-tts>=6.1.0           # Microsoft Edge TTS (free)
wordfreq>=3.0.0           # Word frequency data

# Utils
python-dotenv>=1.0.0
pydantic>=2.6.0
```

### Infrastructure

| Component            | Service                     | Cost (MVP/1 user) |
| -------------------- | --------------------------- | ----------------- |
| Database + Auth      | Supabase Free Tier          | $0/month          |
| AI Service hosting   | Personal server (existing)  | $0/month          |
| Whisper API (OpenAI) | ~30 min/day voice           | ~$6/month         |
| LLM API              | GPT-4o-mini or Claude Haiku | ~$1-3/month       |
| TTS                  | Edge TTS                    | $0 (free)         |
| Free Dictionary API  | dictionaryapi.dev           | $0 (free)         |
| **Total**            |                             | **~$7-9/month**   |

---

## Project Structure

### Flutter App

```
chicky_app/
├── lib/
│   ├── main.dart
│   ├── app.dart                    # App root, GoRouter setup
│   │
│   ├── core/
│   │   ├── config/
│   │   │   ├── env.dart            # Environment variables
│   │   │   └── supabase_config.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── colors.dart
│   │   ├── utils/
│   │   │   ├── lemmatizer.dart     # Simple suffix stripping
│   │   │   └── text_tokenizer.dart
│   │   └── services/
│   │       ├── supabase_service.dart
│   │       ├── api_service.dart    # Dio client for FastAPI
│   │       └── audio_service.dart  # Record + Play
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── presentation/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   └── providers/
│   │   │       └── auth_provider.dart
│   │   │
│   │   ├── vocmap/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── word_model.dart
│   │   │   │   │   ├── user_vocab_model.dart
│   │   │   │   │   └── domain_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── vocab_repository.dart
│   │   │   ├── presentation/
│   │   │   │   ├── vocmap_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── vocab_card.dart
│   │   │   │   │   ├── card_swiper.dart
│   │   │   │   │   ├── domain_list.dart
│   │   │   │   │   └── word_detail_sheet.dart
│   │   │   │   └── review_session_screen.dart
│   │   │   └── providers/
│   │   │       ├── vocmap_provider.dart
│   │   │       ├── review_provider.dart
│   │   │       └── fsrs_provider.dart
│   │   │
│   │   ├── scan/
│   │   │   ├── data/
│   │   │   │   └── repositories/
│   │   │   │       └── scan_repository.dart
│   │   │   ├── presentation/
│   │   │   │   ├── scan_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── text_input_area.dart
│   │   │   │       └── highlighted_text.dart
│   │   │   └── providers/
│   │   │       └── scan_provider.dart
│   │   │
│   │   └── chat/
│   │       ├── data/
│   │       │   ├── models/
│   │       │   │   ├── chat_message_model.dart
│   │       │   │   └── chat_session_model.dart
│   │       │   └── repositories/
│   │       │       └── chat_repository.dart
│   │       ├── presentation/
│   │       │   ├── chat_screen.dart
│   │       │   └── widgets/
│   │       │       ├── message_bubble.dart
│   │       │       ├── correction_card.dart
│   │       │       ├── voice_button.dart
│   │       │       └── mode_selector.dart
│   │       └── providers/
│   │           ├── chat_provider.dart
│   │           ├── voice_provider.dart
│   │           └── wakeword_provider.dart
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── loading_widget.dart
│       │   └── error_widget.dart
│       └── models/
│           └── app_user.dart
│
├── test/
├── pubspec.yaml
└── README.md
```

### FastAPI Service

```
chicky_api/
├── app/
│   ├── main.py                 # FastAPI app, CORS, lifespan
│   ├── config.py               # Environment config
│   ├── database.py             # asyncpg pool setup
│   │
│   ├── routers/
│   │   ├── chat.py             # POST /chat/text, WS /chat/voice
│   │   ├── scan.py             # POST /scan/lookup
│   │   └── tts.py              # POST /tts
│   │
│   ├── services/
│   │   ├── whisper_service.py  # OpenAI Whisper STT
│   │   ├── llm_service.py      # LLM abstraction (Claude/GPT/Gemini)
│   │   ├── tts_service.py      # Edge TTS wrapper
│   │   ├── prompt_builder.py   # Build system prompts with user context
│   │   └── dictionary_service.py  # Free Dictionary API
│   │
│   ├── models/
│   │   ├── chat_models.py      # Pydantic request/response models
│   │   └── scan_models.py
│   │
│   └── utils/
│       ├── auth.py             # Verify Supabase JWT
│       └── text_utils.py       # Sentence splitting, etc.
│
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
└── README.md
```

### Data Pipeline

```
chicky_data_pipeline/
├── scripts/
│   ├── import_oxford5000.py
│   ├── fill_frequency.py
│   ├── fill_definitions.py
│   ├── fill_relationships.py
│   ├── fill_domains.py
│   └── fill_vietnamese.py
├── data/
│   ├── oxford_5000.csv
│   └── domains_seed.json
├── requirements.txt
└── README.md
```

### Supabase Migrations

```
supabase/
├── migrations/
│   ├── 001_create_words.sql
│   ├── 002_create_relationships.sql
│   ├── 003_create_domains.sql
│   ├── 004_create_user_vocabulary.sql
│   ├── 005_create_chat_tables.sql
│   ├── 006_create_scan_sessions.sql
│   ├── 007_create_scenarios.sql
│   ├── 008_enable_rls.sql
│   └── 009_create_indexes.sql
├── seed.sql                    # Initial domain data
└── config.toml
```

---

## Environment Variables

### Flutter (.env)

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJ...
FASTAPI_BASE_URL=http://your-server:8000/api/v1
PICOVOICE_ACCESS_KEY=your-picovoice-key
```

### FastAPI (.env)

```env
SUPABASE_DB_URL=postgresql://postgres:password@db.your-project.supabase.co:5432/postgres
SUPABASE_JWT_SECRET=your-jwt-secret
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...  # optional, for Claude
LLM_PROVIDER=openai  # openai | anthropic | gemini
LLM_MODEL=gpt-4o-mini
WHISPER_MODEL=whisper-1
TTS_VOICE=en-US-AriaNeural
```
