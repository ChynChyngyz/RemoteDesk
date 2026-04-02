import 'package:dio/dio.dart';
import '../models/notification_model.dart';


class NotificationRepository {
  final Dio _dio;

  NotificationRepository(this._dio);

  Future<List<NotificationModel>> getAll(int orgId) async {
    try {
      final response = await _dio.get('orgs/notifications/');
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load Notifications");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? e.toString());
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await _dio.patch(
        'orgs/notifications/$notificationId/',
        data: {"read_at": DateTime.now().toUtc().toIso8601String()},
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to mark notification as read");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? e.toString());
    }
  }
}