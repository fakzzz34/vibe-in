/* 
  Profile Repository
*/

import 'package:vibe_in/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser profileUser);
}
