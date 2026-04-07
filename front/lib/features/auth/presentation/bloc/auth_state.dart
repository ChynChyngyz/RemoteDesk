// features/auth/presentation/bloc/auth_state.dart

import 'package:front/features/auth/domain/entities/user.dart';


abstract class AuthState {}

class AuthInitial extends AuthState {}


class AuthLoading extends AuthState {}


class AuthAuthenticated extends AuthState {
  final User user;
  final String jwtToken;
  AuthAuthenticated(this.user, this.jwtToken);
}


class AuthAgentAuthenticated extends AuthState {
  final String role;
  final String agentKey;
  AuthAgentAuthenticated(this.role, this.agentKey);
}


class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}