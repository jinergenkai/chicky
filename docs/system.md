# Chicky — AI English Companion App

> Single source of truth index. Last updated: 2026-03-09.

---

## What is Chicky?

A mobile AI English companion app for Vietnamese adults learning English. Three core features:

- **VocMap (Vault):** Card-based vocabulary graph with FSRS spaced repetition.
- **Scan Text:** Paste any English text → highlights unknown words → add to vault.
- **AI Buddy Chat:** Voice-activated companion ("Hey Chicky"). Corrects grammar inline, mixes Vietnamese-English naturally.

**Target user (MVP):** The developer himself. Secondary: Vietnamese adults 25-35, ~200-500K VND/month.

---

## Documentation Map

| File | Contents |
|------|----------|
| [architecture.md](architecture.md) | System diagram, tech stack, project folder structure, env vars |
| [database.md](database.md) | All DB tables, indexes, RLS policies, quick-reference queries |
| [features/vocmap.md](features/vocmap.md) | VocMap user flow, card selection algorithm, FSRS, graph queries |
| [features/scan-text.md](features/scan-text.md) | Scan flow, lemmatizer (Dart), Free Dictionary API integration |
| [features/ai-chat.md](features/ai-chat.md) | Buddy/role-play modes, response format, scenario examples |
| [data-pipeline.md](data-pipeline.md) | Bootstrap steps (Oxford 5000 → WordNet → domains), data quality rules |
| [api.md](api.md) | FastAPI endpoint contracts (chat text, voice WS, scan, TTS) |
| [voice-pipeline.md](voice-pipeline.md) | End-to-end voice latency, streaming TTS, Flutter audio handling |
| [prompts.md](prompts.md) | Buddy + role-play system prompts, prompt builder code |
| [roadmap.md](roadmap.md) | MVP phases, cost estimates, future backlog |

---

## Tech Stack (Quick Reference)

| Layer | Choice |
|-------|--------|
| Mobile | Flutter + Riverpod |
| Database + Auth | Supabase (PostgreSQL) |
| AI Service | FastAPI (Python) |
| STT | OpenAI Whisper |
| LLM | GPT-4o-mini (configurable: Claude, Gemini) |
| TTS | Edge TTS (free) |
| Spaced Repetition | FSRS algorithm |
| Wakeword | Picovoice ("Hey Chicky") |
| Local cache | Hive |
