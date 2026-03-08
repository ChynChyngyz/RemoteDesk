// features/auth/data/repositories/auth_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:front/features/auth/domain/entities/user.dart';
import 'package:front/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:front/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthRepositoryImpl implements IAuthRepository {
  final Dio _dio;
  final _storage = const FlutterSecureStorage();

  AuthRepositoryImpl(this._dio);

  @override
  Future<User> login(String phone, String password) async {
    try {
      final response = await _dio.post(
        "login/",
        data: {
          "phone": phone,
          "password": password,
        },
      );

      print('Response: ${response.data}'); // Логирование ответа сервера

      final access = response.data["access"];
      final refresh = response.data["refresh"];

      await _storage.write(key: "access", value: access);
      await _storage.write(key: "refresh", value: refresh);

      _dio.options.headers["Authorization"] = "Bearer $access";

      final userRes = await _dio.get("me/");

      return UserModel.fromJson(userRes.data);
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> register(String phone, String password) async {
    await _dio.post(
      "register/",
      data: {
        "phone": phone,
        "password": password,
      },
    );
  }
}
