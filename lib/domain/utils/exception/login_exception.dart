import 'package:nmsc_todo/domain/utils/enums/login_error_type.dart';

class LoginException implements Exception {
  final LoginErrorType errorType;
  final String message;
  LoginException(this.errorType, this.message);

  @override
  String toString() => 'LoginException: $message';
}
