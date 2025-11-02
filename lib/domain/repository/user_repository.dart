

import 'package:nmsc_todo/core/utils/custom_response.dart';
import 'package:nmsc_todo/domain/models/user_model.dart';

abstract class UserRepository {

  Future<CustomResponse<UserModel, String>> getCurrentUser();

  Future<void> updateProfilePic({
    required String userId,
    required String profileImage,
  });

  Future<CustomResponse<void, String>> updateLoggedInUserProfilePic({
    required String profileImageUrl,
  });
  

  Future<CustomResponse<void, String>> updateUserDisplayName({
    required String newName
  });
}