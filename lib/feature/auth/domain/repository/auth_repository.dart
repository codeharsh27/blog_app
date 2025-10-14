import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/common/entity/user.dart';

abstract interface class AuthRepository{

  Future<Either<Failure, User>> signUpWithEmailPassword({
  required String name,
  required String email,
  required String password,
});

  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure,User>> currentUser();
}