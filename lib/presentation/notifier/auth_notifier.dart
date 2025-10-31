import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  StreamSubscription<AuthState>? _authSub;
  bool _isCheckingSession = true;
  bool _isLoggedIn = false;

  bool get isCheckingSession => _isCheckingSession;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> initialize() async {
    // 1. Check current session (like your splash logic)
    await Future.delayed(const Duration(milliseconds: 1000));
    if(kDebugMode){
      print("Checking current session...");
    }
    final session = _supabase.auth.currentSession;
    _isLoggedIn = session != null;
    _isCheckingSession = false;
    notifyListeners();

    // 2. Listen for auth state changes
    _authSub = _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn) {
        _isLoggedIn = true;
      } else if (event == AuthChangeEvent.signedOut) {
        _isLoggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
