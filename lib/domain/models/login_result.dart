import 'package:nmsc_todo/domain/utils/enums/login_error_type.dart';

sealed class LoginResult {}

class LoginSuccess extends LoginResult {
  final String userId;

  LoginSuccess(this.userId);
}

class LoginFailure extends LoginResult {
  final LoginErrorType errorType;
  final String? message;

  LoginFailure(this.errorType, {this.message});
}

class LoginValidationError extends LoginResult {
  final String message;

  LoginValidationError(this.message);
}
