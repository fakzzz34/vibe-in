import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibe_in/features/profile/domain/entities/profile_user.dart';
import 'package:vibe_in/features/profile/domain/repositories/profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // get user document from firestore
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            username: userData['username'],
            bio: userData['bio'] ?? '',
            profileImage: userData['profileImage'].toString(),
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      // convert updated profile to json  to store in firebase
      await firebaseFirestore
          .collection('users')
          .doc(updatedProfile.uid)
          .update({
            'bio': updatedProfile.bio,
            'profileImage': updatedProfile.profileImage,
          });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
