import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Import local files
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';

const List<String> _scopes = <String>["email", "profile"];

class LoginNotifier extends ChangeNotifier with LoginEventNotifier {
  // --- INJECTED DEPENDENCIES ---
  final GoogleSignIn _googleSignIn;
  final String _clientId;
  final String _serverClientId;
  final SupabaseAuthService _authService;

  // --- INTERNAL STATE & SUBSCRIPTION ---
  bool _isLoading = false;
  late StreamSubscription<GoogleSignInAuthenticationEvent> _googleSubscription;

  bool get isLoading => _isLoading;

  LoginNotifier({
    required GoogleSignIn googleSignIn,
    required String clientId,
    required String serverClientId,
    required SupabaseAuthService authService,
  })  : _googleSignIn = googleSignIn,
        _clientId = clientId,
        _serverClientId = serverClientId,
        _authService = authService;

  // --- LIFECYCLE MANAGEMENT ---

  // REFACTOR: This method initializes the Google streams and state.
  void initializeGoogleSignInAndListen() {
    if (_googleSignIn.authenticationEvents.isBroadcast) {
      // Initialize the Google client with the injected IDs
      unawaited(
        _googleSignIn
            .initialize(clientId: _clientId, serverClientId: _serverClientId)
            .then((_) {
          // Store the subscription for later disposal
          _googleSubscription = _googleSignIn.authenticationEvents
              .listen(_handleAuthenticationEvent)
              ..onError(_handleAuthenticationError);
        }),
      );
    }
  }

  @override
  void dispose() {
    // REFACTOR: Cancel ALL subscriptions managed by the Notifier.
    _googleSubscription.cancel();
    super.dispose();
  }

  // --- STATE MODIFICATION ---

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // --- CORE LOGIN LOGIC (Email/Password) ---

  void login(String email, String password) async {
    if (isLoading) return;
    setLoading(true);
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      emitLoginEvent(LoginSuccessEvent());
    } catch (e) {
      emitLoginEvent(LoginErrorEvent(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  // --- GOOGLE SIGN-IN LOGIC (Manual Click) ---

  // This is called when the user clicks the GoogleLogin button.
  Future<void> signInWithGoogle() async {
    if (isLoading) return;
    setLoading(true);
    try {
      await _googleSignIn.authenticate();
      // The rest of the authentication flow is handled by the stream listener.
    } catch (e) {
      _handleAuthenticationError(e); // Use the same error handler for consistency
    } finally {
      setLoading(false);
    }
  }

  // Attempts the fast, silent login
  void attemptLightweightGoogleAuth() {
    _googleSignIn.attemptLightweightAuthentication();
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
      await _authService.signInWithGoogle(idToken, authorizationToken);
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
    emitLoginEvent(LoginErrorEvent(errorMessage));
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    // REFACTOR: Error mapping logic is now centralized in the Notifier.
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled.',
      _ => 'Google Sign-in failed: ${e.description}',
    };
  }
}