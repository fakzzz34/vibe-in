import 'package:vibe_in/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImage;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required super.username,
    required this.bio,
    required this.profileImage,
  });

  ProfileUser copyWith({String? newBio, String? newProfileImage}) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      username: username,
      bio: newBio ?? bio,
      profileImage: newProfileImage ?? profileImage,
    );
  }

  // convert profile to json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'username': username,
      'bio': bio,
      'profileImage': profileImage,
    };
  }

  // convert json to profile
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      bio: json['bio'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
