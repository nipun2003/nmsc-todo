import 'package:nmsc_todo/domain/models/user_model.dart';

class UserDto {
  final String id;
  final String email;
  final String name;
  final String username;
  final String profilePic;
  final DateTime createdAt;
  final DateTime? updatedAt; // Nullable in DB

  UserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.profilePic,
    required this.createdAt,
    this.updatedAt,
  });

  /// Factory method to create a UserDto from the Supabase JSON response (Map).
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      profilePic: json['profile_pic'] as String,
      // Supabase returns timestamps as ISO 8601 strings
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String).toLocal()
          : null,
    );
  }

  /// Converts the UserDto to a JSON Map, useful for updating the database.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'profile_pic': profilePic,
      // We usually don't send createdAt/updatedAt back, but good for completeness.
    };
  }

  UserModel toUserModel() {
    // Check if profilePic is an empty string and convert it to null if necessary,
    // which is a common practice for optional model fields.
    final String? userProfilePic = profilePic.isNotEmpty ? profilePic : null;

    return UserModel(
      id: id,
      name: name,
      username: username,
      email: email,
      profilePicUrl: userProfilePic,
      memberSince: createdAt, // Using createdAt as the 'member since' date
    );
  }
}
