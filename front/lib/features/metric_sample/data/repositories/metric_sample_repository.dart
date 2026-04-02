import 'package:dio/dio.dart';
import '../models/metric_sample_model.dart';

class MetricSampleRepository {
  final Dio _dio;

  MetricSampleRepository(this._dio);

  Future<List<MetricSampleModel>> getAll(int orgId) async {
    try {
      final response = await _dio.get('orgs/metrics/');
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => MetricSampleModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load Metric Samples");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? e.toString());
    }
  }
}