import 'package:flutter/foundation.dart';
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
    if(kDebugMode){
      print("Sign-in response for Email: $email - Session: ${response.session}, User ID: ${response.user?.id}");
    }
    if (response.session == null && response.user == null) {
      throw Exception("Login failed: Invalid credentials or unverified email.");
    }

    final bool emailConfirmed = response.user?.emailConfirmedAt != null;
    if(kDebugMode){
      print("User ${response.user?.id} email confirmed: $emailConfirmed");
    }
    if (!emailConfirmed) {
      throw Exception("Login failed: Email not verified.");
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

  Future<String> signUpWithEmailAndPassword(
    {
      required String email,
      required String password,
      required String fullName,
    }
  ) async {
    if(kDebugMode){
      print("Signing up user with Email: $email, Name: $fullName");
    }
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        "name": fullName,
      }
    );
    if (response.user == null) {
      throw Exception("Sign-up failed: Unable to create user.");
    }
    return response.user!.id;
  }
}
