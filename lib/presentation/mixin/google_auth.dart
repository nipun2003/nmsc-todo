import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';

const List<String> _scopes = <String>["email", "profile"];
mixin GoogleAuth on ChangeNotifier {
  GoogleSignIn get googleSignIn;
  String get clientId;
  String get serverClientId;

  SupabaseAuthService get authService;

  void emitLoginEvent(LoginEvent event);

  bool get isLoading;
  void setLoading(bool loading);

  late StreamSubscription<GoogleSignInAuthenticationEvent> _googleSubscription;

  void initializeGoogleSignInAndListen() {
    if (googleSignIn.authenticationEvents.isBroadcast) {
      // Initialize the Google client with the injected IDs
      unawaited(
        googleSignIn
            .initialize(clientId: clientId, serverClientId: serverClientId)
            .then((_) {
              // Store the subscription for later disposal
              _googleSubscription = googleSignIn.authenticationEvents.listen(
                _handleAuthenticationEvent,
              )..onError(_handleAuthenticationError);
            }),
      );
    }
  }

  // Attempts the fast, silent login
  void attemptLightweightGoogleAuth() {
    googleSignIn.attemptLightweightAuthentication();
  }

  // This is called when the user clicks the GoogleLogin button.
  Future<void> signInWithGoogle() async {
    if (isLoading) return;
    setLoading(true);
    try {
      await googleSignIn.authenticate();
      // The rest of the authentication flow is handled by the stream listener.
    } catch (e) {
      _handleAuthenticationError(
        e,
      ); // Use the same error handler for consistency
    } finally {
      setLoading(false);
    }
  }

  // --- GOOGLE STREAM HANDLERS (Moved from UI) ---

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    if (isLoading) return;
    setLoading(true); // Set loading while we process the stream event
    try {
      final GoogleSignInAccount? user = switch (event) {
        GoogleSignInAuthenticationEventSignIn() => event.user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };

      final idToken = user?.authentication.idToken;
      if (idToken == null) {
        emitLoginEvent(LoginErrorEvent("Couldn't retrieve ID Token."));
        return;
      }

      final GoogleSignInClientAuthorization? authorization = await user
          ?.authorizationClient
          .authorizationForScopes(_scopes);

      if (authorization == null) {
        emitLoginEvent(LoginErrorEvent("Couldn't retrieve authorization."));
        return;
      }

      final authorizationToken = authorization.accessToken;
      await authService.signInWithGoogle(idToken, authorizationToken);
      emitLoginEvent(LoginSuccessEvent());
    } catch (e) {
      emitLoginEvent(LoginErrorEvent(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    final errorMessage = e is GoogleSignInException
        ? _errorMessageFromSignInException(e)
        : 'Unknown error: $e';
    if (kDebugMode) {
      print('Google Sign-In Error: $errorMessage');
    }
    emitLoginEvent(LoginErrorEvent(errorMessage));
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    // REFACTOR: Error mapping logic is now centralized in the Notifier.
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled.',
      _ => 'Google Sign-in failed: ${e.description}',
    };
  }

  @override
  void dispose() {
    _googleSubscription.cancel();
    super.dispose();
  }
}
