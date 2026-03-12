// features/auth/data/models/user_model.dart

import 'package:front/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String phone,
    required String role,
    required int organization,
  }) : super(
    id: id,
    phone: phone,
    role: role,
    organization: organization,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {

    int orgId = 0;

    if (json['organization'] != null) {
      orgId = json['organization']['id'];
    }

    return UserModel(
      id: json['id'],
      phone: json['phone'],
      role: json['role'],
      organization: orgId,
    );
  }
}