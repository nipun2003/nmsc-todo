import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Import local files
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';
import 'package:nmsc_todo/presentation/mixin/google_auth.dart';

class LoginNotifier extends ChangeNotifier with LoginEventNotifier, GoogleAuth {
  // --- INJECTED DEPENDENCIES ---
  final GoogleSignIn _googleSignIn;
  final String _clientId;
  final String _serverClientId;
  final SupabaseAuthService _authService;

  // --- INTERNAL STATE & SUBSCRIPTION ---
  bool _isLoading = false;
  late StreamSubscription<GoogleSignInAuthenticationEvent> _googleSubscription;

  @override
  bool get isLoading => _isLoading;

  LoginNotifier({
    required GoogleSignIn googleSignIn,
    required String clientId,
    required String serverClientId,
    required SupabaseAuthService authService,
  }) : _googleSignIn = googleSignIn,
       _clientId = clientId,
       _serverClientId = serverClientId,
       _authService = authService;

  @override
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

  @override
  void dispose() {
    // REFACTOR: Cancel ALL subscriptions managed by the Notifier.
    _googleSubscription.cancel();
    super.dispose();
  }

  @override
  GoogleSignIn get googleSignIn {
    return _googleSignIn;
  }

  @override
  String get clientId {
    return _clientId;
  }

  @override
  String get serverClientId {
    return _serverClientId;
  }

  @override
  SupabaseAuthService get authService {
    return _authService;
  }
}
