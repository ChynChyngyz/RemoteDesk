// features/auth/data/models/user_model.dart

import 'package:front/features/auth/domain/entities/user.dart';


class UserModel extends User {
  UserModel(
      {
        required int id,
        required String phone}
      ) :
        super
          (id: id, phone: phone);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], phone: json['phone']);
  }
}

