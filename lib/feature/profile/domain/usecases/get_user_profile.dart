import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';
import 'package:blog_app/feature/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserProfile implements Usecase<UserProfile, GetUserProfileParams> {
  final ProfileRepository profileRepository;

  GetUserProfile(this.profileRepository);

  @override
  Future<Either<Failure, UserProfile>> call(GetUserProfileParams params) async {
    return await profileRepository.getProfile(params.userId);
  }
}

class GetUserProfileParams {
  final String userId;

  GetUserProfileParams({required this.userId});
}
