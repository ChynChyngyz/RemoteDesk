// features/auth/domain/repositories/i_auth_repository.dart

import 'package:front/features/auth/domain/entities/user.dart';
import 'package:front/features/auth/domain/entities/agent.dart';

abstract class IAuthRepository {
  Future<User> login(String phone, String password);
  Future<Agent> loginWithToken(String hashToken);
}