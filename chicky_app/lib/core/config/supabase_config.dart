import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static SupabaseQueryBuilder from(String table) => client.from(table);

  static String? get currentUserId => client.auth.currentUser?.id;

  static bool get isLoggedIn => client.auth.currentUser != null;

  /// Stream of auth state changes
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}
