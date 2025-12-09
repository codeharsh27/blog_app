import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';
import 'package:fpdart/fpdart.dart';

import 'dart:io';

abstract interface class ProfileRepository {
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile);
  Future<Either<Failure, UserProfile>> getProfile(String userId);
  Future<Either<Failure, String>> uploadProfileImage({
    required File image,
    required String userId,
  });
}
