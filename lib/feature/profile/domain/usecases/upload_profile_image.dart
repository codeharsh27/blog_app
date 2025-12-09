import 'dart:io';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadProfileImage implements Usecase<String, UploadProfileImageParams> {
  final ProfileRepository profileRepository;

  UploadProfileImage(this.profileRepository);

  @override
  Future<Either<Failure, String>> call(UploadProfileImageParams params) async {
    return await profileRepository.uploadProfileImage(
      image: params.image,
      userId: params.userId,
    );
  }
}

class UploadProfileImageParams {
  final File image;
  final String userId;

  UploadProfileImageParams({required this.image, required this.userId});
}
