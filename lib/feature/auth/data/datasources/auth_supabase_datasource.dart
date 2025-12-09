import 'package:blog_app/core/error/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user_model.dart';

abstract interface class AuthSupabaseSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithGithub();
  Future<UserModel> signInWithFacebook();
}

class AuthSupabaseSourceImpl implements AuthSupabaseSource {
  final SupabaseClient supabaseClient;
  AuthSupabaseSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        final sessionUser = currentUserSession!.user;
        final sessionName = sessionUser.userMetadata?['name'];
        final sessionEmail = sessionUser.email;

        if (userData.isNotEmpty) {
          final profileData = Map<String, dynamic>.from(userData.first);
          // Fallback to session name if profile name is missing
          if (profileData['name'] == null ||
              profileData['name'].toString().isEmpty) {
            if (sessionName != null) {
              profileData['name'] = sessionName;
            }
          }
          // Ensure email is present
          if (profileData['email'] == null ||
              profileData['email'].toString().isEmpty) {
            profileData['email'] = sessionEmail;
          }
          return UserModel.fromJson(profileData);
        }

        // If no profile data found, construct from session
        return UserModel(
          id: sessionUser.id,
          email: sessionEmail ?? '',
          name: sessionName ?? '',
          skills: [],
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerException("User cannot be null!");
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerException("User cannot be null!");
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      if (e.message.contains('User already registered')) {
        throw ServerException('User is already exist');
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    return _signInWithProvider(OAuthProvider.google);
  }

  @override
  Future<UserModel> signInWithGithub() async {
    return _signInWithProvider(OAuthProvider.github);
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    return _signInWithProvider(OAuthProvider.facebook);
  }

  Future<UserModel> _signInWithProvider(OAuthProvider provider) async {
    try {
      final bool isSuccess = await supabaseClient.auth.signInWithOAuth(
        provider,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      if (!isSuccess) {
        throw ServerException("Social login failed!");
      }

      return UserModel(
        id: 'pending',
        email: 'pending@social.login',
        name: 'Pending',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
