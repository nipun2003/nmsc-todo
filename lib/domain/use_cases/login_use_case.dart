import 'package:nmsc_todo/domain/models/login_result.dart';
import 'package:nmsc_todo/domain/repository/auth_repository.dart';
import 'package:nmsc_todo/domain/validators/email_validator.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  final EmailValidator _emailValidator;

  LoginUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository,
      _emailValidator = EmailValidator();

  Future<LoginResult> execute(String email, String password) {
    if (!_emailValidator.isValid(email)) {
      return Future.value(LoginValidationError("Invalid email format."));
    }
    return _authRepository.loginWithEmail(email, password);
  }
}
