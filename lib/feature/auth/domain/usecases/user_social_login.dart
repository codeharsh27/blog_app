import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/common/entity/user.dart';

class UserSocialLogin implements Usecase<User, UserSocialLoginParams> {
  final AuthRepository authRepository;
  const UserSocialLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSocialLoginParams params) async {
    return switch (params.provider) {
      SocialProvider.google => await authRepository.signInWithGoogle(),
      SocialProvider.github => await authRepository.signInWithGithub(),
      SocialProvider.facebook => await authRepository.signInWithFacebook(),
    };
  }
}

class UserSocialLoginParams {
  final SocialProvider provider;
  UserSocialLoginParams(this.provider);
}

enum SocialProvider { google, github, facebook }
