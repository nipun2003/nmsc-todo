import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nmsc_todo/data/remote/service/supabase_auth_service.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';
import 'package:nmsc_todo/presentation/mixin/google_auth.dart';

class AuthLayoutNotifier extends ChangeNotifier
    with GoogleAuth {
  final GoogleSignIn _googleSignIn;
  final String _clientId;
  final String _serverClientId;
  final SupabaseAuthService _authService;
  final LoginEventBus _eventBus;

  AuthLayoutNotifier({
    required GoogleSignIn googleSignIn,
    required String clientId,
    required String serverClientId,
    required SupabaseAuthService authService,
    required LoginEventBus eventBus,
  }) : _googleSignIn = googleSignIn,
       _clientId = clientId,
       _serverClientId = serverClientId,
       _authService = authService,
       _eventBus = eventBus;


  bool _isLoading = false;

  @override
  SupabaseAuthService get authService => _authService;

  Stream<LoginEvent> get loginEvents => _eventBus.loginEvents;

  @override
  String get clientId => _clientId;

  @override
  GoogleSignIn get googleSignIn => _googleSignIn;

  @override
  bool get isLoading => _isLoading;

  @override
  String get serverClientId => _serverClientId;

  @override
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  @override
  void emitLoginEvent(LoginEvent event) {
    _eventBus.emitLoginEvent(event);
  }
}
