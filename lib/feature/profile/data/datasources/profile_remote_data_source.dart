import 'dart:io';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/feature/profile/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserProfileModel> updateProfile(UserProfileModel profile);
  Future<UserProfileModel?> getProfile(String userId);
  Future<String> uploadProfileImage({
    required File image,
    required String userId,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .upsert(profile.toJson())
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserProfileModel?> getProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage({
    required File image,
    required String userId,
  }) async {
    try {
      final imagePath = '$userId/profile_image';
      await supabaseClient.storage
          .from('avatars')
          .upload(
            imagePath,
            image,
            fileOptions: const FileOptions(upsert: true),
          );
      return supabaseClient.storage.from('avatars').getPublicUrl(imagePath);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
