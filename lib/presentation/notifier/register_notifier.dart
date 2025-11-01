import 'package:flutter/foundation.dart';
import 'package:nmsc_todo/core/utils/custom_response.dart';
import 'package:nmsc_todo/domain/use_cases/register_use_case.dart';
import 'package:nmsc_todo/presentation/events/register_events.dart';
import 'package:nmsc_todo/presentation/utils/validators.dart';

/// RegisterNotifier for handling user registration form state.
class RegisterNotifier extends ChangeNotifier {
  bool _isLoading = false;
  Uint8List? _file;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _nameError;

  // --- Getters ---
  bool get isLoading => _isLoading;
  Uint8List? get file => _file;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get nameError => _nameError;
  bool get isFormValid =>
      _emailError == null && _passwordError == null && _nameError == null && _file != null;

  final RegisterUseCase? _registerUseCase;
  final RegisterEventBus? _eventBus;

  RegisterNotifier({
    RegisterUseCase? registerUseCase,
    RegisterEventBus? eventBus,
  })  : _registerUseCase = registerUseCase,
        _eventBus = eventBus;

  // --- Validation methods ---
  void validateName(String value) {
    _nameError = UIValidators.validateName(value.trim());
    notifyListeners();
  }

  void validateEmail(String value) {
    _emailError = UIValidators.validateEmail(value.trim());
    notifyListeners();
  }

  void validatePassword(String value, String confirmPassword) {
    _passwordError = UIValidators.validatePassword(value.trim());
    notifyListeners();
    if (confirmPassword.isNotEmpty) {
      validateConfirmPassword(confirmPassword, value);
    }
  }

  void validateConfirmPassword(String value, String originalPassword) {
    if (value != originalPassword) {
      _confirmPasswordError = 'Passwords do not match';
    } else {
      _confirmPasswordError = null;
    }
    notifyListeners();
  }

  void setFile(Uint8List? bytes) {
    _file = bytes;
    notifyListeners();
  }

  // --- Auth logic ---
  Future<void> register({
    required String name,
    required String email,
    required String password,
    Uint8List? file,
  }) async {
    if (_isLoading) return;

    // Basic validations
    _nameError = name.trim().isEmpty ? 'Name is required' : null;
    _emailError = UIValidators.validateEmail(email.trim());
    _passwordError = UIValidators.validatePassword(password.trim());
    notifyListeners();

    if (_nameError != null || _emailError != null || _passwordError != null) return;

    setLoading(true);

    try {
      final ruc = _registerUseCase;
      if (ruc != null) {
        final res = await ruc.execute(name, email, password, file);
        if (res is SuccessResponse) {
          _eventBus?.emitRegisterEvent(RegisterSuccessEvent());
        } else if (res is ErrorResponse) {
          _eventBus?.emitRegisterEvent(RegisterErrorEvent(res.message ?? 'Unknown error'));
        } else {
          // Fallback
          _eventBus?.emitRegisterEvent(RegisterSuccessEvent());
        }
      } else {
        // No use-case provided, emit success as a fallback
        _eventBus?.emitRegisterEvent(RegisterSuccessEvent());
      }
    } catch (e) {
      _eventBus?.emitRegisterEvent(RegisterErrorEvent(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
