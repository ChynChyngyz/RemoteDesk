// features/auth/domain/repositories/i_auth_repository.dart

import 'package:front/features/auth/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<User> login(String phone, String password);
  Future<void> register(String phone, String password);
}