import 'dart:typed_data';

import 'package:nmsc_todo/core/utils/custom_response.dart';
import 'package:nmsc_todo/domain/repository/auth_repository.dart';
import 'package:nmsc_todo/domain/repository/file_upload_repository.dart';
import 'package:nmsc_todo/domain/repository/user_repository.dart';
import 'package:nmsc_todo/domain/utils/enums/register_error_type.dart';
import 'package:nmsc_todo/domain/utils/exception/file_upload_exception.dart';
import 'package:nmsc_todo/domain/utils/exception/register_exception.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final FileUploadRepository _fileUploadRepository;

  RegisterUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required FileUploadRepository fileUploadRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository,
       _fileUploadRepository = fileUploadRepository;

  Future<CustomResponse<void, RegisterErrorType>> execute(
    String name,
    String email,
    String password,
    Uint8List? profileImage,
  ) async {
    // Simulate network delay
    try {
      final userId = await _authRepository.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );

      if (profileImage != null) {
        final imageUrl = await _fileUploadRepository.uploadAvatar(
          userId: userId,
          imageData: profileImage,
        );
        await _userRepository.updateProfilePic(
          userId: userId,
          profileImage: imageUrl,
        );
      }
      return SuccessResponse(null);
    } on RegisterException catch (e) {
      return ErrorResponse(e.message, e.errorType);
    } on FileUploadException catch (e) {
      return ErrorResponse(e.message, RegisterErrorType.profileUpdateFailed);
    } catch (e) {
      return ErrorResponse(e.toString(), RegisterErrorType.unknown);
    }
  }
}
