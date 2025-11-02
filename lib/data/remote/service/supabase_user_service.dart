import 'package:nmsc_todo/data/remote/dto/user_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Assuming UserDto is defined in a separate file (e.g., user_dto.dart)
// import 'user_dto.dart'; 

class SupabaseUserService {
  final _supabase = Supabase.instance.client;

  /// Retrieves the current user from Supabase Auth.
  Future<User?> getAuthUser() async {
    final response = await _supabase.auth.getUser();
    return response.user;
  }

  /// Retrieves the current user's profile information as a UserDto.
  Future<UserDto?> getCurrentUserProfile() async {
    final user = await getAuthUser();

    if (user == null) {
      return null;
    }

    try {
      final userId = user.id;

      // 1. Query the 'users' table for the profile matching the auth ID.
      final Map<String, dynamic> data = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      // 2. Convert the Map<String, dynamic> response to a UserDto object.
      return UserDto.fromJson(data);
    } on PostgrestException catch (e) {
      print('Error fetching user profile: ${e.message}');
      return null;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null;
    }
  }

  // --- Functions to Update Profile Attributes ---

  /// Updates profile attributes in the 'users' table using a Map.
  /// Used internally by the specific update functions.
  Future<void> _updateLoggedInUserAttribute(Map<String, dynamic> attributes) async {
    final user = await getAuthUser();

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    await _supabase
        .from('users')
        .update(attributes)
        .eq('id', user.id);
  }

  Future<void> _updateProfileAttributes(String userId,Map<String, dynamic> attributes) async {

    await _supabase
        .from('users')
        .update(attributes)
        .eq('id', userId);
  }

  /// Updates the user's name in the 'users' table.
  Future<void> updateUserDisplayName(String newName) async {
    await _updateLoggedInUserAttribute({'name': newName, 'updated_at': DateTime.now().toIso8601String()});
  }

  Future<void> updateUserProfilePic({
    required String userId,
    required String profileImage,
  }){
    return _updateProfileAttributes(userId, {'profile_pic': profileImage, 'updated_at': DateTime.now().toIso8601String()});
  }

  /// Updates the user's username in the 'users' table.
  Future<void> updateUsername(String newUsername) async {
    await _updateLoggedInUserAttribute({'username': newUsername, 'updated_at': DateTime.now().toIso8601String()});
  }

  /// Updates the user's profile picture URL in the 'users' table.
  Future<void> updateCurrentUserProfilePic(String newProfilePicUrl) async {
    await _updateLoggedInUserAttribute({'profile_pic': newProfilePicUrl, 'updated_at': DateTime.now().toIso8601String()});
  }
}