import 'package:flutter/foundation.dart';
import 'package:nmsc_todo/core/utils/custom_response.dart';
import 'package:nmsc_todo/data/remote/service/supabase_user_service.dart';
import 'package:nmsc_todo/domain/models/user_model.dart';
import 'package:nmsc_todo/domain/repository/user_repository.dart';
import 'package:nmsc_todo/domain/utils/exception/file_upload_exception.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseUserService _sUserService;
  UserRepositoryImpl(this._sUserService);
  @override
  Future<CustomResponse<UserModel, String>> getCurrentUser() async {
    try {
      final userDto = await _sUserService.getCurrentUserProfile();
      if (userDto == null) {
        return ErrorResponse("User not found", "User not found");
      } else {
        final userModel = userDto.toUserModel();
        return SuccessResponse(userModel);
      }
    } catch (e) {
      return ErrorResponse(e.toString(), e.toString());
    }
  }

  @override
  Future<void> updateProfilePic({
    required String userId,
    required String profileImage,
  }) async {
    try {
      await _sUserService.updateUserProfilePic(
        userId: userId,
        profileImage: profileImage,
      );
      if (kDebugMode) {
        print("Profile picture updated successfully for User ID: $userId");
      }
    } catch (e) {
      throw FileUploadException(
        "Failed to update profile picture: ${e.toString()}",
      );
    }
  }

  @override
  Future<CustomResponse<void, String>> updateUserDisplayName({
    required String newName,
  }) async {
    try {
      await _sUserService.updateUserDisplayName(newName);
      return SuccessResponse(null);
    } catch (e) {
      return ErrorResponse(e.toString(), e.toString());
    }
  }

  @override
  Future<CustomResponse<void, String>> updateLoggedInUserProfilePic({
    required String profileImageUrl,
  }) async {
    try {
      await _sUserService.updateCurrentUserProfilePic(profileImageUrl);
      return SuccessResponse(null);
    } catch (e) {
      return ErrorResponse(e.toString(), e.toString());
    }
  }
}
