/*
  PROFILE STATE
*/

import 'package:vibe_in/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

// initial
class ProfileInitial extends ProfileState {}

// loading
class ProfileLoading extends ProfileState {}

// authenticated
class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

// unauthenticated
class ProfileUnauthenticated extends ProfileState {}

// error
class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
