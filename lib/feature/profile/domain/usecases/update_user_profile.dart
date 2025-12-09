import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';
import 'package:blog_app/feature/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserProfile
    implements Usecase<UserProfile, UpdateUserProfileParams> {
  final ProfileRepository profileRepository;

  UpdateUserProfile(this.profileRepository);

  @override
  Future<Either<Failure, UserProfile>> call(
    UpdateUserProfileParams params,
  ) async {
    return await profileRepository.updateProfile(params.profile);
  }
}

class UpdateUserProfileParams {
  final UserProfile profile;

  UpdateUserProfileParams(this.profile);
}
