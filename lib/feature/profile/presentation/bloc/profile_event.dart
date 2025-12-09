import 'dart:io';
import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final UserProfile profile;

  ProfileUpdateRequested(this.profile);
}

class ProfileImageUploadRequested extends ProfileEvent {
  final File image;
  final String userId;

  ProfileImageUploadRequested({required this.image, required this.userId});
}

class ProfileFetchRequested extends ProfileEvent {
  final String userId;

  ProfileFetchRequested({required this.userId});
}
