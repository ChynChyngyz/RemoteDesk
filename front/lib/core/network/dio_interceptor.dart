// core/dio_interceptor.dart

import 'package:dio/dio.dart';
import 'package:front/core/errors/error_handler.dart';

class DioInterceptor extends Interceptor {

  String? accessToken;

  void setToken(String token) {
    accessToken = token;
  }

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {

    if (accessToken != null) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }

    handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {

    final message = ErrorHandler.parse(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: message,
      ),
    );
  }
}