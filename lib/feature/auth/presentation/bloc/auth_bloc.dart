import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/auth/domain/usecases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_social_login.dart'
    as us;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/entity/user.dart';
import '../../domain/usecases/user_signin.dart';
import '../../domain/usecases/user_signup.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final us.UserSocialLogin _userSocialLogin;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required us.UserSocialLogin userSocialLogin,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       _userSocialLogin = userSocialLogin,
       super(AuthInitial()) {
    on<AuthSignup>(_onAuthSignUp);
    on<AuthSignin>(_onAuthSignIn);
    on<AuthLogout>(_onAuthLogout);
    on<AuthCurrentUser>(_onAuthCurrentUser);
    on<AuthSocialLogin>(_onAuthSocialLogin);
  }

  void _onAuthCurrentUser(
    AuthCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  // Sign Up logic
  void _onAuthSignUp(AuthSignup event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  // Sign In logic
  void _onAuthSignIn(AuthSignin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignIn(
      UserSignInParams(email: event.email, password: event.password),
    );
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  // Social Login logic
  void _onAuthSocialLogin(
    AuthSocialLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final provider = switch (event.provider) {
      SocialProvider.google => us.SocialProvider.google,
      SocialProvider.github => us.SocialProvider.github,
      SocialProvider.facebook => us.SocialProvider.facebook,
    };

    final res = await _userSocialLogin(us.UserSocialLoginParams(provider));
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  // Logout logic
  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    _appUserCubit.updateUser(null);
    emit(AuthFailure('Logged Out'));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
