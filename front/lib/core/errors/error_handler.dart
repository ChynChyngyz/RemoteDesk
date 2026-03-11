import 'package:dio/dio.dart';

class ErrorHandler {

  static String parse(DioException error) {

    final data = error.response?.data;

    if (data != null) {

      if (data is Map) {

        if (data["error"] != null) {
          return data["error"].toString();
        }

        if (data["detail"] != null) {
          return data["detail"].toString();
        }

        // ошибки serializer DRF
        final key = data.keys.first;
        final value = data[key];

        if (value is List) {
          return value.first.toString();
        }

        return value.toString();
      }

      return data.toString();
    }

    switch (error.type) {

      case DioExceptionType.connectionTimeout:
        return "Connection timeout";

      case DioExceptionType.receiveTimeout:
        return "Server not responding";

      case DioExceptionType.connectionError:
        return "No internet connection";

      case DioExceptionType.badCertificate:
        return "Bad SSL certificate";

      case DioExceptionType.cancel:
        return "Request cancelled";

      default:
        return "Unexpected server error";
    }
  }
}