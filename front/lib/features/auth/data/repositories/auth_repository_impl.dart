// features/auth/data/repositories/auth_repository_impl.dart

import 'package:dio/dio.dart';
import 'package:front/features/auth/domain/entities/user.dart';
import 'package:front/features/auth/domain/entities/agent.dart';
import 'package:front/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:front/features/auth/data/models/user_model.dart';
import 'package:front/features/auth/data/models/agent_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/core/errors/error_handler.dart';


class AuthRepositoryImpl implements IAuthRepository {

  final Dio _dio;
  final _storage = const FlutterSecureStorage();

  AuthRepositoryImpl(this._dio);

  @override
  Future<User> login(String phone, String password) async {

    try {

      final response = await _dio.post(
        "auth/login/",
        data: {
          "phone": phone,
          "password": password,
        },
      );

      final access = response.data["access"];
      final refresh = response.data["refresh"];

      await _storage.write(key: "access", value: access);
      await _storage.write(key: "refresh", value: refresh);

      _dio.options.headers["Authorization"] = "Bearer $access";

      final userRes = await _dio.get("auth/me/");

      return UserModel.fromJson(userRes.data);

    } on DioException catch (e) {

      throw Exception(ErrorHandler.parse(e));

    } catch (_) {

      throw Exception("Unexpected error");

    }
  }

  @override
  Future<Agent> loginWithToken(String hashToken) async {

    try {

      final response = await _dio.post(
        "agent/login_agent/",
        data: {
          "agent_key": hashToken,
        },
      );

      return AgentModel.fromJson(response.data);

    } on DioException catch (e) {

      throw Exception(ErrorHandler.parse(e));

    } catch (_) {

      throw Exception("Unexpected error");

    }
  }

}