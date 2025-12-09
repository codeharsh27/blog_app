import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded(this.profile);
}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

final class ProfileImageUploaded extends ProfileState {
  final String imageUrl;

  ProfileImageUploaded(this.imageUrl);
}
