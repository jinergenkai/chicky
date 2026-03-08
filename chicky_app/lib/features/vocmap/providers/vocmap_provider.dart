import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/domain_model.dart';
import '../data/models/user_vocab_model.dart';
import '../data/repositories/vocab_repository.dart';

part 'vocmap_provider.g.dart';

// ── Repository provider ───────────────────────────────────────────────────

final vocabRepositoryProvider = Provider<VocabRepository>(
  (_) => VocabRepository(),
);

// ── Domains ───────────────────────────────────────────────────────────────

@riverpod
Future<List<DomainModel>> domains(DomainsRef ref) async {
  final repo = ref.watch(vocabRepositoryProvider);
  final flat = await repo.getDomains();
  return DomainModelX.buildTree(flat);
}

// ── Review queue ──────────────────────────────────────────────────────────

@riverpod
Future<List<UserVocabModel>> reviewCards(ReviewCardsRef ref) async {
  final repo = ref.watch(vocabRepositoryProvider);
  return repo.getReviewCards();
}

@riverpod
Future<List<UserVocabModel>> newCards(NewCardsRef ref) async {
  final repo = ref.watch(vocabRepositoryProvider);
  return repo.getNewCards();
}

// ── Vocab stats ───────────────────────────────────────────────────────────

@riverpod
Future<Map<String, int>> vocabStats(VocabStatsRef ref) async {
  final repo = ref.watch(vocabRepositoryProvider);
  return repo.getVocabStats();
}

// ── Selected domain ───────────────────────────────────────────────────────

final selectedDomainProvider = StateProvider<DomainModel?>((ref) => null);

// ── Domain words ──────────────────────────────────────────────────────────

@riverpod
Future<List<dynamic>> domainWords(DomainWordsRef ref) async {
  final domain = ref.watch(selectedDomainProvider);
  if (domain == null) return [];
  final repo = ref.watch(vocabRepositoryProvider);
  return repo.getDomainWords(domain.id);
}
