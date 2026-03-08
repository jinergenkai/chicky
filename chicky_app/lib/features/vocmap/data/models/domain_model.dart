import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_model.freezed.dart';
part 'domain_model.g.dart';

@freezed
class DomainModel with _$DomainModel {
  const factory DomainModel({
    required String id,
    required String name,
    @JsonKey(name: 'parent_id') String? parentId,
    String? icon,
    // Children loaded separately when building the hierarchy
    @Default([]) List<DomainModel> children,
    // Word count for display
    @JsonKey(name: 'word_count') @Default(0) int wordCount,
  }) = _DomainModel;

  factory DomainModel.fromJson(Map<String, dynamic> json) =>
      _$DomainModelFromJson(json);
}

extension DomainModelX on DomainModel {
  bool get isRootDomain => parentId == null;

  String get displayIcon => icon ?? '📚';

  /// Builds a domain tree from a flat list.
  static List<DomainModel> buildTree(List<DomainModel> flat) {
    final Map<String, DomainModel> byId = {for (final d in flat) d.id: d};
    final roots = <DomainModel>[];

    for (final domain in flat) {
      if (domain.parentId == null) {
        roots.add(domain);
      } else {
        final parent = byId[domain.parentId];
        if (parent != null) {
          byId[domain.parentId!] = parent.copyWith(
            children: [...parent.children, domain],
          );
        }
      }
    }

    return roots;
  }
}
