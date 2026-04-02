import 'package:dio/dio.dart';
import '../models/audit_model.dart';


class AuditEventRepository {
  final Dio _dio;

  AuditEventRepository(this._dio);

  Future<List<AuditEventModel>> getAll(int orgId) async {
    try {
      final response = await _dio.get('orgs/audit/');
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => AuditEventModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load Audit Events");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? e.toString());
    }
  }
}