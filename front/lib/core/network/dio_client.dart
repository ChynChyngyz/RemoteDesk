// core/dio_client.dart

import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class DioClient {
  static final DioInterceptor interceptor = DioInterceptor();
  static final Dio dio = Dio(
    BaseOptions(
      // baseUrl: "http://127.0.0.1:8000/api/v1/",
      baseUrl: "http://127.0.0.1/api/v1/",
      headers: {
        "Content-Type": "application/json",
      },
      followRedirects: true,
    ),
  );

  Future<void> login(String phone, String password) async {
    try {
      final response = await dio.post(
        '/login/',
        data: {
          'phone': phone,
          'password': password,
        },
      );
      print("Login Success: ${response.data}");
    } catch (e) {
      print("Login Error: $e");
    }
  }

  Future<void> register(String phone, String password) async {
    try {
      final response = await dio.post(
        '/register/',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      print("Register Response: ${response.data}");

      if (response.statusCode == 200) {
      } else {
        print("Registration failed: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error during registration: $e");
    }
  }
}