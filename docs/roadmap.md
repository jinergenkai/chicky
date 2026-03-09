# MVP Milestones & Roadmap

---

## Phase 1: Foundation (Week 1-2)

- [ ] Setup Supabase project + run all migrations
- [ ] Run data pipeline: import Oxford 5000 + WordNet
- [ ] Flutter project setup: Riverpod, Supabase SDK, routing
- [ ] Auth flow: login/register with Supabase Auth
- [ ] Basic UI shell: bottom navigation (VocMap, Scan, Chat)

## Phase 2: VocMap (Week 3-4)

- [ ] Card UI component with swipe gestures
- [ ] Review session: FSRS algorithm integration
- [ ] New word cards with weighted random selection
- [ ] Domain browser: list domains → show words
- [ ] Word detail sheet: definition, IPA, related words
- [ ] Local cache with Hive for offline vocab access

## Phase 3: Scan Text (Week 5)

- [ ] Text input area with paste support
- [ ] Simple lemmatizer implementation
- [ ] Color-coded text display (known/learning/unknown)
- [ ] Tap word → show detail + "Add to Vault"
- [ ] Free Dictionary API integration for unknown words
- [ ] FastAPI endpoint: /scan/lookup

## Phase 4: AI Chat — Text Mode (Week 6-7)

- [ ] FastAPI service setup with asyncpg
- [ ] Chat UI: message bubbles, correction cards
- [ ] Prompt builder with learning word injection
- [ ] LLM integration (GPT-4o-mini initially)
- [ ] Grammar correction display in chat
- [ ] Chat session/message persistence in Supabase

## Phase 5: AI Chat — Voice Mode (Week 8-9)

- [ ] Picovoice wakeword integration ("Hey Chicky")
- [ ] Audio recording + send to FastAPI
- [ ] Whisper STT integration
- [ ] Edge TTS integration
- [ ] WebSocket streaming: sentence-level TTS
- [ ] Audio playback queue in Flutter

## Phase 6: Polish & Deploy (Week 10)

- [ ] Role-play mode + 3 initial scenarios
- [ ] Error handling, loading states, offline fallbacks
- [ ] Deploy FastAPI (Docker on personal server)
- [ ] Flutter web build for browser testing
- [ ] Flutter Android build for personal device
- [ ] End-to-end testing

**Total estimated time: 10 weeks (part-time, evenings/weekends)**

---

## Cost Estimation

### Monthly Cost (1 user — personal use)

| Service             | Usage                            | Cost            |
| ------------------- | -------------------------------- | --------------- |
| Supabase            | Free tier (500MB DB, 50K MAU)    | $0              |
| Whisper API         | ~30 min/day × 30 days = 15 hours | ~$5.40          |
| LLM (GPT-4o-mini)   | ~100 messages/day                | ~$1-3           |
| Edge TTS            | Unlimited                        | $0              |
| Free Dictionary API | Unlimited                        | $0              |
| Personal server     | Already owned                    | $0              |
| **Total**           |                                  | **~$7-9/month** |

### Monthly Cost (100 users — early growth)

| Service                 | Usage              | Cost              |
| ----------------------- | ------------------ | ----------------- |
| Supabase Pro            | Needed at ~50K MAU | $25               |
| Whisper API             | ~50 hours total    | ~$18              |
| LLM API                 | ~10K messages      | ~$10-30           |
| Server (Railway/Fly.io) | Small instance     | ~$10-20           |
| **Total**               |                    | **~$63-93/month** |

Revenue target to break even (100 users): At 300K VND/month (~$12): 100 users × $12 = $1,200/month → profitable from ~8 paying users.

---

## Future Backlog

### High Priority

- [ ] Scan history UI (data already collected in scan_sessions)
- [ ] Grammar error analytics dashboard ("Top 5 mistakes you make")
- [ ] Push notifications for FSRS review reminders
- [ ] Vietnamese definitions batch import
- [ ] User-contributed definitions (community feature)

### Medium Priority

- [ ] Camera OCR scan (scan physical books/menus)
- [ ] Multi-language support (language column in words table)
- [ ] Lemma lookup table (replace simple suffix stripping)
- [ ] More role-play scenarios (20+)
- [ ] Conversation topic suggestions based on domain progress
- [ ] Audio pronunciation for vocabulary cards
- [ ] Social features: leaderboard, study groups

### Low Priority / Exploration

- [ ] Offline AI chat (local LLM on device)
- [ ] iOS app store deployment
- [ ] Integration with external content (news articles, YouTube subtitles)
- [ ] Gamification (streaks, achievements, XP)
- [ ] Admin dashboard for content management
- [ ] A/B testing FSRS parameters
