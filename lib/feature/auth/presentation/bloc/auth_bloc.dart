import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/auth/domain/usecases/current_user.dart';
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

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit)=> emit(AuthLoading()));
    on<AuthSignup>(_onAuthSignUp);
    on<AuthSignin>(_onAuthSignIn);
    on<AuthCurrentUser>(_onAuthCurrentUser);
  }

  void _onAuthCurrentUser(AuthCurrentUser event, Emitter<AuthState> emit) async{
    final res = await _currentUser(NoParams());
    res.fold(
        (failure)=> emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit)
        );
  }

  // Sign Up logic
  void _onAuthSignUp(AuthSignup event, Emitter<AuthState> emit) async {
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
    final res = await _userSignIn(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit){
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
