import '../../../../core/common/entity/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.skills,
  });
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? map['user_metadata']?['name'] ?? '',
      email: map['email'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }
}
