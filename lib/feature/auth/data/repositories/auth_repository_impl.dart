import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/feature/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:blog_app/feature/auth/data/model/user_model.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/common/entity/user.dart';

class AuthRepositoriesImpl implements AuthRepository {
  final AuthSupabaseSource supabaseSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoriesImpl(this.supabaseSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = supabaseSource.currentUserSession;

        if (session == null) {
          return left(Failure('User is not LoggedIn'));
        }

        return right(
          UserModel(
            id: session.user.id,
            name: '',
            email: session.user.email ?? '',
          ),
        );
      }
      final user = await supabaseSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User not logged in!"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await supabaseSource.signInWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await supabaseSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet COnnection !'));
      }
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    return _getUser(() async => await supabaseSource.signInWithGoogle());
  }

  @override
  Future<Either<Failure, User>> signInWithGithub() async {
    return _getUser(() async => await supabaseSource.signInWithGithub());
  }

  @override
  Future<Either<Failure, User>> signInWithFacebook() async {
    return _getUser(() async => await supabaseSource.signInWithFacebook());
  }
}
