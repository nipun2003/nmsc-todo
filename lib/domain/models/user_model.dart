

class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? profilePicUrl; // Simplified to be nullable for app logic
  final DateTime memberSince;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profilePicUrl,
    required this.memberSince,
  });

  // You can add helper methods here, e.g.,
  String get displayName => name.isNotEmpty ? name : username;
}