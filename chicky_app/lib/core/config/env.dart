import 'package:flutter/services.dart';

class Env {
  Env._();

  static final Map<String, String> _values = {};

  static Future<void> load({String fileName = '.env'}) async {
    try {
      final contents = await rootBundle.loadString(fileName);
      for (final line in contents.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final idx = trimmed.indexOf('=');
        if (idx == -1) continue;
        final key = trimmed.substring(0, idx).trim();
        final value = trimmed.substring(idx + 1).trim().replaceAll('"', '');
        _values[key] = value;
      }
    } catch (_) {
      // .env not bundled in release; rely on compile-time constants or CI injection
    }
  }

  static String _require(String key) {
    final v = _values[key];
    if (v == null || v.isEmpty) {
      throw StateError('Missing required env variable: $key');
    }
    return v;
  }

  static String get supabaseUrl => _require('SUPABASE_URL');
  static String get supabaseAnonKey => _require('SUPABASE_ANON_KEY');
  static String get apiBaseUrl => _values['API_BASE_URL'] ?? 'http://localhost:8000';
  static String get picovoiceAccessKey => _values['PICOVOICE_ACCESS_KEY'] ?? '';
}
