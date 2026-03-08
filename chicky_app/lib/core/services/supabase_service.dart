import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton wrapper around the Supabase client.
class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  GoTrueClient get auth => client.auth;

  String? get currentUserId => auth.currentUser?.id;

  bool get isAuthenticated => auth.currentUser != null;

  // ── Auth helpers ──────────────────────────────────────────────────────────

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) =>
      auth.signInWithPassword(email: email, password: password);

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) =>
      auth.signUp(email: email, password: password, data: data);

  Future<void> signOut() => auth.signOut();

  Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // ── Generic DB helpers ────────────────────────────────────────────────────

  SupabaseQueryBuilder from(String table) => client.from(table);

  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
    int? limit,
    String? orderBy,
    bool ascending = true,
  }) async {
    var query = client.from(table).select(columns);
    if (filters != null) {
      for (final entry in filters.entries) {
        query = query.eq(entry.key, entry.value) as SupabaseQueryBuilder;
      }
    }
    // Note: chained ordering/limiting done by caller via raw client for complex queries
    return await query;
  }

  Future<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    final result = await client.from(table).insert(data).select().single();
    return result;
  }

  Future<void> update(
    String table,
    Map<String, dynamic> data, {
    required String matchColumn,
    required dynamic matchValue,
  }) async {
    await client.from(table).update(data).eq(matchColumn, matchValue);
  }

  Future<void> upsert(String table, Map<String, dynamic> data) async {
    await client.from(table).upsert(data);
  }

  Future<void> delete(
    String table, {
    required String matchColumn,
    required dynamic matchValue,
  }) async {
    await client.from(table).delete().eq(matchColumn, matchValue);
  }
}
