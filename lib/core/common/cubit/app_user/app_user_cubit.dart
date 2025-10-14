import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/user.dart';
part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User ? user){
    if(user == null){
      emit(AppUserInitial());
    }else{
      emit(AppUserLoggedIn(user));
    }
  }
}
