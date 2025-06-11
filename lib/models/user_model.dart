// File: lib/models/user_model.dart
// Represents a user profile object

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String avatarUrl;

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.avatarUrl,
  });

  /// Factory constructor to create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
    );
  }

  /// Convert this UserModel to a map for storage or serialization
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
    };
  }
}
