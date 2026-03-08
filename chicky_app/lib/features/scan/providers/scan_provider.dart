import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/scan_repository.dart';
import '../../vocmap/data/models/word_model.dart';

// ── Repository ────────────────────────────────────────────────────────────

final scanRepositoryProvider = Provider<ScanRepository>(
  (_) => ScanRepository(),
);

// ── Scan state ────────────────────────────────────────────────────────────

class ScanState {
  const ScanState({
    this.text = '',
    this.result,
    this.isLoading = false,
    this.error,
    this.selectedWord,
  });

  final String text;
  final ScanResult? result;
  final bool isLoading;
  final String? error;
  final WordModel? selectedWord;

  ScanState copyWith({
    String? text,
    ScanResult? result,
    bool? isLoading,
    String? error,
    WordModel? selectedWord,
    bool clearResult = false,
    bool clearError = false,
    bool clearSelectedWord = false,
  }) {
    return ScanState(
      text: text ?? this.text,
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedWord:
          clearSelectedWord ? null : (selectedWord ?? this.selectedWord),
    );
  }
}

class ScanNotifier extends StateNotifier<ScanState> {
  ScanNotifier(this._ref) : super(const ScanState());

  final Ref _ref;

  ScanRepository get _repo => _ref.read(scanRepositoryProvider);

  void updateText(String text) {
    state = state.copyWith(text: text, clearResult: true, clearError: true);
  }

  Future<void> scan() async {
    if (state.text.trim().isEmpty) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _repo.scanText(state.text);

      // Save scan session in background
      _repo.saveScanSession(
        text: state.text,
        wordCount: result.tokens.length,
        unknownCount: result.unknownWords.length,
      );

      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> selectWord(String lemma) async {
    state = state.copyWith(isLoading: true, clearSelectedWord: true);
    final word = await _repo.lookupWord(lemma);
    state = state.copyWith(isLoading: false, selectedWord: word);
  }

  Future<void> addWordToVault(String wordId) async {
    await _repo.addToVault(wordId);
  }

  void clear() {
    state = const ScanState();
  }
}

final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>(
  (ref) => ScanNotifier(ref),
);
