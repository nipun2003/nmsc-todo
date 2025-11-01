import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nmsc_todo/domain/use_cases/login_use_case.dart';
import 'package:nmsc_todo/presentation/events/login_events.dart';
import 'package:nmsc_todo/presentation/utils/validators.dart';

class LoginNotifier extends ChangeNotifier {

  final LoginUseCase _loginUseCase;
  final LoginEventBus _eventBus;

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  // --- Getters ---
  bool get isLoading => _isLoading;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  bool get isFormValid =>
      _emailError == null && _passwordError == null;

  LoginNotifier({
    required LoginUseCase loginUseCase,
    required LoginEventBus eventBus,
  }) : _loginUseCase = loginUseCase,
       _eventBus = eventBus;

  // --- Validation methods ---
  void validateEmail(String value) {
    _emailError = UIValidators.validateEmail(value.trim());
    notifyListeners();
  }

  void validatePassword(String value) {
    _passwordError = UIValidators.validatePassword(value.trim());
    notifyListeners();
  }

  // --- Auth logic ---
  Future<void> login(String email, String password) async {
    if (_isLoading) return;
    _emailError = UIValidators.validateEmail(email);
    _passwordError = UIValidators.validatePassword(password);
    notifyListeners();

    if (_emailError != null || _passwordError != null) return;

    setLoading(true);

    try {
      await _loginUseCase.execute(email, password);
      _eventBus.emitLoginEvent(LoginSuccessEvent());
    } catch (e) {
      _eventBus.emitLoginEvent(LoginErrorEvent(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
