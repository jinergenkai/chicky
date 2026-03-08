import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<AuthState> authState(AuthStateRef ref) {
  return SupabaseService.instance.authStateChanges;
}

@riverpod
User? currentUser(CurrentUserRef ref) {
  return SupabaseService.instance.auth.currentUser;
}

// ── Auth notifier ──────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await SupabaseService.instance.signInWithEmail(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await SupabaseService.instance.signUpWithEmail(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await SupabaseService.instance.signOut();
    });
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (_) => AuthNotifier(),
);
