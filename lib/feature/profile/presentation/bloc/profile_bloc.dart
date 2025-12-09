import 'package:blog_app/feature/profile/domain/usecases/get_user_profile.dart';
import 'package:blog_app/feature/profile/domain/usecases/update_user_profile.dart';
import 'package:blog_app/feature/profile/domain/usecases/upload_profile_image.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_event.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateUserProfile _updateUserProfile;
  final UploadProfileImage _uploadProfileImage;
  final GetUserProfile _getUserProfile;

  ProfileBloc({
    required UpdateUserProfile updateUserProfile,
    required UploadProfileImage uploadProfileImage,
    required GetUserProfile getUserProfile,
  }) : _updateUserProfile = updateUserProfile,
       _uploadProfileImage = uploadProfileImage,
       _getUserProfile = getUserProfile,
       super(ProfileInitial()) {
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileImageUploadRequested>(_onProfileImageUploadRequested);
    on<ProfileFetchRequested>(_onProfileFetchRequested);
  }

  void _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final res = await _updateUserProfile(
      UpdateUserProfileParams(event.profile),
    );

    res.fold(
      (l) => emit(ProfileError(l.message)),
      (r) => emit(ProfileLoaded(r)),
    );
  }

  void _onProfileImageUploadRequested(
    ProfileImageUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final res = await _uploadProfileImage(
      UploadProfileImageParams(image: event.image, userId: event.userId),
    );

    res.fold(
      (l) => emit(ProfileError(l.message)),
      (r) => emit(ProfileImageUploaded(r)),
    );
  }

  void _onProfileFetchRequested(
    ProfileFetchRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final res = await _getUserProfile(
      GetUserProfileParams(userId: event.userId),
    );

    res.fold(
      (l) => emit(ProfileError(l.message)),
      (r) => emit(ProfileLoaded(r)),
    );
  }
}
