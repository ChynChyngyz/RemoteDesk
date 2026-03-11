// features/auth/data/models/user_model.dart

import 'package:front/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String phone,
    required String role,
  }) : super(
    id: id,
    phone: phone,
    role: role,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
