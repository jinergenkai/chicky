import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

@freezed
class WordModel with _$WordModel {
  const factory WordModel({
    required String id,
    required String word,
    String? ipa,
    @Default([]) List<Map<String, dynamic>> definitions,
    String? cefrLevel,
    int? frequencyRank,
    @Default([]) List<String> exampleSentences,
    @Default(false) bool verified,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // Optional: Vietnamese translation from fill_vietnamese pipeline
    @JsonKey(name: 'vi_translation') String? viTranslation,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);
}

extension WordModelX on WordModel {
  /// Returns the primary part of speech from definitions list.
  String? get primaryPos {
    if (definitions.isEmpty) return null;
    return definitions.first['pos'] as String?;
  }

  /// Returns the first English definition string.
  String? get primaryDefinition {
    if (definitions.isEmpty) return null;
    final defs = definitions.first['definitions'] as List?;
    if (defs == null || defs.isEmpty) return null;
    return defs.first as String?;
  }

  /// Returns a display-friendly CEFR badge label.
  String get cefrBadge => cefrLevel?.toUpperCase() ?? '';

  /// Whether the word has a known IPA pronunciation.
  bool get hasIpa => ipa != null && ipa!.isNotEmpty;
}
