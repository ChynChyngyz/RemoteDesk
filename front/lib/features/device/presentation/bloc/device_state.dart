import '../../data/models/device_model.dart';

abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final List<DeviceModel> items;
  DeviceLoaded(this.items);
}

class DeviceError extends DeviceState {
  final String message;
  DeviceError(this.message);
}
