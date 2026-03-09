# Voice Pipeline

## End-to-End Flow

```
User says "Hey Chicky"
  ↓ ~200ms (Picovoice on-device, offline)

App starts recording (Record package)
  ↓ User speaks... silence detection (~500ms pause)

Audio sent to FastAPI via WebSocket
  ↓
FastAPI: Whisper API (speech → text)
  ↓ ~0.5-1s for ~10s audio

FastAPI: Build prompt (inject learning words + history)
  ↓
FastAPI: LLM streaming response
  ↓ First token ~0.3s, then streaming

FastAPI: Sentence-level streaming TTS
  ↓ Each complete sentence → Edge TTS → audio chunk → WebSocket

Flutter: Play audio chunks as they arrive
  ↓ User hears first sentence after ~2-3s total

Total perceived latency: ~2-3s (with streaming)
Without streaming: ~4-6s (wait for full response)
```

---

## FastAPI Streaming Implementation

```python
# FastAPI WebSocket endpoint with sentence-level streaming TTS
import edge_tts
import io

@app.websocket("/chat/voice")
async def voice_chat(websocket: WebSocket):
    await websocket.accept()

    # 1. Receive audio
    config = await websocket.receive_json()  # {type: "start", session_id, mode}
    audio_chunks = []
    while True:
        data = await websocket.receive()
        if isinstance(data, dict) and data.get("type") == "end":
            break
        audio_chunks.append(data)

    audio_data = b"".join(audio_chunks)

    # 2. Whisper STT
    transcript = await whisper_transcribe(audio_data)
    await websocket.send_json({"type": "transcript", "text": transcript})

    # 3. Build prompt with user context
    user_id = get_user_from_token(config.get("token"))
    learning_words = await get_learning_words(user_id)
    prompt = build_buddy_prompt(transcript, learning_words, config["mode"])

    # 4. LLM streaming + sentence-level TTS
    buffer = ""
    async for chunk in llm_stream(prompt):
        buffer += chunk

        # Check for sentence boundary
        for sep in ['. ', '? ', '! ', '.\n', '?\n', '!\n']:
            if sep in buffer:
                sentence, buffer = buffer.split(sep, 1)
                sentence += sep.strip()

                # TTS this sentence
                audio_bytes = await tts_sentence(sentence)
                await websocket.send_bytes(audio_bytes)

    # Handle remaining buffer
    if buffer.strip():
        audio_bytes = await tts_sentence(buffer.strip())
        await websocket.send_bytes(audio_bytes)

    # 5. Send final metadata
    full_response = parse_llm_response(full_text)
    await websocket.send_json({
        "type": "done",
        "reply_text": full_response["reply"],
        "corrections": full_response["corrections"],
        "vocab_used": full_response["vocab_used"]
    })


async def tts_sentence(text: str, voice: str = "en-US-AriaNeural") -> bytes:
    """Convert a sentence to audio using Edge TTS."""
    communicate = edge_tts.Communicate(text, voice)
    audio_buffer = io.BytesIO()
    async for chunk in communicate.stream():
        if chunk["type"] == "audio":
            audio_buffer.write(chunk["data"])
    return audio_buffer.getvalue()
```

---

## Flutter Audio Handling

```dart
// Simplified voice chat flow in Flutter
class VoiceChatService {
  late WebSocketChannel _channel;
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final Queue<Uint8List> _audioQueue = Queue();

  Future<void> startVoiceChat(String sessionId, String mode) async {
    // 1. Connect WebSocket
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://your-server:8000/chat/voice?token=$jwt')
    );

    // 2. Send start signal
    _channel.sink.add(jsonEncode({
      'type': 'start',
      'session_id': sessionId,
      'mode': mode
    }));

    // 3. Listen for responses
    _channel.stream.listen((data) {
      if (data is String) {
        final json = jsonDecode(data);
        if (json['type'] == 'transcript') {
          // Show user's transcribed text
        } else if (json['type'] == 'done') {
          // Show corrections, update vocab
        }
      } else if (data is List<int>) {
        // Audio chunk → add to queue → play
        _audioQueue.add(Uint8List.fromList(data));
        _playNextChunk();
      }
    });

    // 4. Start recording
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.pcm16bits),
      path: tempPath,
    );
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    // Send audio to WebSocket
    final audioBytes = await File(tempPath).readAsBytes();
    _channel.sink.add(audioBytes);
    _channel.sink.add(jsonEncode({'type': 'end'}));
  }
}
```
