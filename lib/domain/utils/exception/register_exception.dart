import 'package:nmsc_todo/domain/utils/enums/register_error_type.dart';

class RegisterException implements Exception {
  final String message;
  final RegisterErrorType errorType;
  RegisterException(this.errorType, this.message);

  @override
  String toString() => 'RegisterException: $message';
}
