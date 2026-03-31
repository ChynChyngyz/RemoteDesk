// core/dio_admin.dart

import 'package:dio/dio.dart';
import 'dio_client.dart';

class DioAdmin {

  static final Dio _dio = DioClient.dio;

  /// USERS

  static Future<Response> getUsers() {
    return _dio.get("orgs/users/");
  }

  static Future<Response> createUser({
    required String phone,
    required String password,
    required String role,
    required int organization,
  }) {
    return _dio.post(
      "orgs/users/",
      data: {
        "phone": phone,
        "password": password,
        "role": role,
        "organization": organization,
      },
    );
  }

  static Future<void> deleteUser(int id) async {
    await _dio.delete("orgs/users/$id/");
  }

  /// ORGANIZATION

  static Future<Response> createOrganization({
    required String name,
    required String city,
    required String industry,
  }) async {
    try {
      final response = await _dio.post(
        "orgs/organizations/",
        data: {
          "name": name,
          "city": city,
          "industry": industry,
          "is_active": true,
        },
      );
      return response;
    } on DioException catch (e) {
      throw e;
    }
  }

  static Future<Response> getOrganization(int orgId) {
    return _dio.get("orgs/organizations/$orgId/");
  }

  /// TOKEN

  static Future<Response> generateAgentToken() {
    return _dio.post("auth/generate_agent_token/");
  }
  
  /// TICKETS & COMMENTS

  static Future<Response> getTickets() {
    return _dio.get("orgs/tickets/");
  }

  static Future<Response> getTicketComments(int ticketId) {
    return _dio.get("orgs/tickets/$ticketId/comments/");
  }

  static Future<Response> createTicketComment(int ticketId, String body) {
    return _dio.post(
      "orgs/tickets/$ticketId/comments/",
      data: {"body": body},
    );
  }
}