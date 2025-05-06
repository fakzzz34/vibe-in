import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_in/features/profile/domain/repositories/profile_repository.dart';
import 'package:vibe_in/features/storage/domain/repositories/storage_repository.dart';

import 'profile_state.dart';

class ProfileCubits extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final StorageRepository storageRepository;

  ProfileCubits({
    required this.profileRepository,
    required this.storageRepository,
  }) : super(ProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());

      final user = await profileRepository.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError(message: 'User not found'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  // update bio and or profile picture

  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    try {
      emit(ProfileLoading());

      final currentUser = await profileRepository.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError(message: 'Failed to fetch user for profile update'));
        return;
      }

      // profile picture update
      String? imageDownloadUrl;

      // ensure there is an image
      if (imageWebBytes != null || imageMobilePath != null) {
        // for mobile
        if (imageMobilePath != null) {
          imageDownloadUrl = await storageRepository.uploadProfileImageMobile(
            imageMobilePath,
            uid,
          );
        }
        // for web
        else if (imageWebBytes != null) {
          imageDownloadUrl = await storageRepository.uploadProfileImageWeb(
            imageWebBytes,
            uid,
          );
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError(message: 'Failed to upload image'));
          return;
        }
      }

      // update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImage: imageDownloadUrl ?? currentUser.profileImage,
      );

      // update in repo
      await profileRepository.updateProfile(updatedProfile);

      //re-fetch the updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError(message: 'Error updateing profile: $e'));
    }
  }
}
