// features/auth/presentation/bloc/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/auth/domain/repositories/i_auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> login(String phone, String password) async {
    emit(AuthLoading());

    try {
      final user = await repository.login(phone, password);
      final token = await repository.getAccessToken();

      emit(AuthAuthenticated(user, token ?? ''));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> loginWithToken(String hashToken) async {
    emit(AuthLoading());

    try {
      final agent = await repository.loginWithToken(hashToken);

      // Передаем hashToken в состояние
      emit(AuthAgentAuthenticated(agent.role, hashToken));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}