import 'dart:io';
import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

/// Wrapper around [AudioRecorder] (record package) and [AudioPlayer] (just_audio).
class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _isRecording = false;
  String? _currentRecordPath;

  // ── Recording ─────────────────────────────────────────────────────────────

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<void> startRecording() async {
    if (_isRecording) return;
    if (!await _recorder.hasPermission()) {
      throw StateError('Microphone permission denied');
    }

    final dir = await getTemporaryDirectory();
    _currentRecordPath =
        '${dir.path}/chicky_record_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: _currentRecordPath!,
    );
    _isRecording = true;
  }

  /// Stops recording and returns the recorded [File], or null on failure.
  Future<File?> stopRecording() async {
    if (!_isRecording) return null;
    final path = await _recorder.stop();
    _isRecording = false;
    if (path == null) return null;
    return File(path);
  }

  Future<Uint8List?> stopRecordingAsBytes() async {
    final file = await stopRecording();
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    await file.delete();
    return bytes;
  }

  bool get isRecording => _isRecording;

  // ── Playback ──────────────────────────────────────────────────────────────

  Future<void> playFromBytes(Uint8List bytes) async {
    await _player.stop();
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.dataFromBytes(bytes, mimeType: 'audio/mpeg'),
      ),
    );
    await _player.play();
  }

  Future<void> playFromUrl(String url) async {
    await _player.stop();
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> playFromFile(File file) async {
    await _player.stop();
    await _player.setFilePath(file.path);
    await _player.play();
  }

  Future<void> stopPlayback() async {
    await _player.stop();
  }

  Future<void> pausePlayback() async {
    await _player.pause();
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;

  bool get isPlaying => _player.playing;

  Future<void> dispose() async {
    await _recorder.dispose();
    await _player.dispose();
  }
}
