import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class SupabaseManager {
  static bool _isInitialized = false;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize(String environment) async {
    if (_isInitialized) return;
    env = environment;
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _isInitialized = true;
  }
}
