import 'package:dio/dio.dart';

import 'package:front/features/incident/data/models/incident_model.dart';

class IncidentRepository {
  final Dio _dio;

  IncidentRepository(this._dio);

  Future<List<IncidentModel>> getAll(int orgId) async {
    try {
      final response = await _dio.get('orgs/incidents/');

      if (response.statusCode == 200) {
        final data = response.data as List;

        return data
            .map((json) => IncidentModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load Incidents");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? e.toString());
    }
  }

  Future<void> acknowledgeIncident(int incidentId) async {
    try {
      final response = await _dio.patch(
        'orgs/incidents/$incidentId/',
        data: {"status": "ACKNOWLEDGED"},
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to acknowledge incident");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? e.toString());
    }
  }
}