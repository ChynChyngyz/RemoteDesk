import 'package:dio/dio.dart';
import 'package:front/features/device/data/models/device_model.dart';

class DeviceRepository {
  final Dio _dio;

  DeviceRepository(this._dio);

  Future<List<DeviceModel>> getAll(int orgId) async {
    try {
      final response = await _dio.get('orgs/devices/');

      if (response.statusCode == 200) {
        final data = response.data as List;

        return data
            .map((json) => DeviceModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load Devices");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? e.toString());
    }
  }

  Future<void> createDevice(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        'orgs/devices/',
        data: data,
      );
      if (response.statusCode != 201) {
        throw Exception("Failed to create device");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? e.toString());
    }
  }
}