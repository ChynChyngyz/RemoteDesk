import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_state.dart';
import '../../data/repositories/device_repository.dart';
import '../../data/models/device_model.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final DeviceRepository repository;

  DeviceCubit(this.repository) : super(DeviceInitial());

  Future<void> fetchAll(int orgId) async {
    emit(DeviceLoading());
    try {
      final items = await repository.getAll(orgId);
      emit(DeviceLoaded(items));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> create(Map<String, dynamic> data, int orgId) async {
    try {
      await repository.createDevice(data);
      await fetchAll(orgId);
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
}