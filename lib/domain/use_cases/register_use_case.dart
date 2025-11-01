import 'dart:typed_data';

import 'package:nmsc_todo/core/utils/custom_response.dart';
import 'package:nmsc_todo/domain/utils/enums/register_error_type.dart';

class RegisterUseCase {
  Future<CustomResponse<void, RegisterErrorType>> execute(
    String name,
    String email,
    String password,
    Uint8List? profileImage,
  ) async {
    // Simulate network delay
   return Future.value(SuccessResponse<void, RegisterErrorType>(null));
  }
}
