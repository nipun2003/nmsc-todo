import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.session == null && response.user == null) {
      throw Exception("Login failed: Invalid credentials or unverified email.");
    }
    return response.user!.id;
  }

  Future<void> signInWithGoogle(
    String idToken,
    String authorizationToken,
  ) async {
    try {
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorizationToken,
      );
      if (response.session == null && response.user == null) {
        throw Exception("Google sign-in failed: Invalid credentials.");
      }
    } on AuthException catch (e) {
      throw Exception("Google sign-in failed: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }
}

final supabaseAuthService = SupabaseAuthService();
