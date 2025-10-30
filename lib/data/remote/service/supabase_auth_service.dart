import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session == null && response.user == null) {
        throw Exception(
          "Login failed: Invalid credentials or unverified email.",
        );
      }
    } on AuthException catch (e) {
      throw Exception("Login failed: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }
}
