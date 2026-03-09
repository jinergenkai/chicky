# Feature: AI Buddy Chat

Voice-activated AI English companion. User says "Hey Chicky" → speaks → Chicky responds with grammar correction + natural conversation in mixed Vietnamese-English. Also available as text chat.

---

## Two Modes

| Mode           | Description                                                          | When to use                                          |
| -------------- | -------------------------------------------------------------------- | ---------------------------------------------------- |
| **Buddy Chat** | Free conversation, grammar correction, knowledge Q&A, mixed Vi-En    | Default. 80% of usage. Walking, commuting, studying. |
| **Role-play**  | Structured scenarios (job interview, ordering food, etc.) with goals | Practice specific situations before real encounters. |

---

## Chicky's Personality

Chicky is a smart, warm, slightly humorous AI companion. Not a teacher — a friend who happens to be great at English.

Key traits:
- Warm but not cheesy. Smart friend at a café vibe.
- Has opinions. Recommends things. Shares perspectives.
- Corrects grammar naturally (repeats corrected version, doesn't lecture).
- Uses Vietnamese when it helps, defaults to English.
- Remembers context within session.

---

## Response Format

When user makes a grammar error:

```
📝 Correction (spoken first):
"Oh you WENT to the bank yesterday?"

💬 Reply (then content):
"What for — chuyện gì vậy? Were you applying for a loan?"

📌 Vocab note (subtle, text only):
"mortgage", "collateral" highlighted as learning words
```

In voice: Bot reads the corrected sentence naturally (as if confirming what user said), pauses briefly, then responds to content. User hears the correct form before the conversation continues.

---

## Bot Response JSON Format

FastAPI returns structured response:

```json
{
  "reply": "Oh you went to the bank yesterday? What for — chuyện gì vậy? Were you applying for a loan?",
  "corrections": [
    {
      "original": "I go to bank yesterday",
      "corrected": "I went to the bank yesterday",
      "rule": "past_simple",
      "explanation": "Use past tense 'went' for completed past actions"
    }
  ],
  "vocab_used": ["mortgage", "loan"],
  "vocab_ids": ["uuid-1", "uuid-2"]
}
```

Flutter parses this to:
- Play audio of `reply` (via Edge TTS)
- Store `corrections` in `chat_messages.corrections`
- Highlight `vocab_used` in chat UI
- Update `user_vocabulary` tracking for practiced words

---

## Role-play Scenarios

```json
[
  {
    "title": "Job Interview — Software Engineer",
    "description": "User is interviewing for a senior backend engineer position at a fintech company.",
    "character": "You are Sarah, a friendly but thorough Engineering Manager at a fintech startup.",
    "difficulty": "intermediate",
    "domain": "Technology",
    "suggested_vocab": ["scalability", "microservices", "deployment", "collaborate", "initiative"]
  },
  {
    "title": "Ordering at a Restaurant",
    "description": "User is ordering food at an American restaurant.",
    "character": "You are Mike, a friendly waiter at a casual American restaurant.",
    "difficulty": "beginner",
    "domain": "Food & Drink",
    "suggested_vocab": ["appetizer", "entree", "dessert", "recommend", "allergy"]
  },
  {
    "title": "Business Meeting — Project Update",
    "description": "User is presenting a project status update to their team lead.",
    "character": "You are David, a supportive but detail-oriented team lead.",
    "difficulty": "intermediate",
    "domain": "Business",
    "suggested_vocab": ["deadline", "milestone", "stakeholder", "prioritize", "bottleneck"]
  }
]
```
