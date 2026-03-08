import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? createdAt;

  factory AppUser.fromSupabaseUser(User user) {
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      createdAt: user.createdAt != null ? DateTime.tryParse(user.createdAt!) : null,
    );
  }

  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    return email.isNotEmpty ? email[0].toUpperCase() : '?';
  }

  AppUser copyWith({
    String? displayName,
    String? avatarUrl,
  }) {
    return AppUser(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }

  @override
  String toString() => 'AppUser(id: $id, email: $email)';
}
