import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/device_entity.dart';

// --- СОБЫТИЯ (EVENTS) ---

abstract class ClientDevicesEvent extends Equatable {
  const ClientDevicesEvent();

  @override
  List<Object?> get props => [];
}

/// Событие запроса списка устройств
class FetchClientDevices extends ClientDevicesEvent {
  const FetchClientDevices();
}

// --- СОСТОЯНИЯ (STATES) ---

abstract class ClientDevicesState extends Equatable {
  const ClientDevicesState();

  @override
  List<Object?> get props => [];
}

/// Исходное состояние / Загрузка
class ClientDevicesLoading extends ClientDevicesState {
  const ClientDevicesLoading();
}

/// Успешная загрузка данных (может быть пустым списком)
class ClientDevicesLoaded extends ClientDevicesState {
  final List<DeviceEntity> devices;

  const ClientDevicesLoaded({required this.devices});

  @override
  List<Object?> get props => [devices];
}

class ClientDevicesError extends ClientDevicesState {
  final String message;

  const ClientDevicesError({required this.message});

  @override
  List<Object?> get props => [message];
}


class ClientDevicesBloc extends Bloc<ClientDevicesEvent, ClientDevicesState> {

  ClientDevicesBloc() : super(const ClientDevicesLoading()) {
    on<FetchClientDevices>(_onFetchClientDevices);
  }

  Future<void> _onFetchClientDevices(
      FetchClientDevices event,
      Emitter<ClientDevicesState> emit,
      ) async {
    emit(const ClientDevicesLoading());

    try {
      // Имитация задержки сети (заменишь на вызов UseCase)
      await Future.delayed(const Duration(milliseconds: 1500));

      // Имитация ответа от UseCase (твои реальные данные)
      final mockDevices = [
        DeviceEntity(
          id: 'dev_101',
          hostname: 'DESKTOP-CEO-MAIN',
          os: 'Windows 11 Pro',
          lastSeenAt: DateTime.now().subtract(const Duration(minutes: 2)),
          status: 'ONLINE',
        ),
        DeviceEntity(
          id: 'dev_102',
          hostname: 'LAPTOP-ACC-01',
          os: 'Windows 10',
          lastSeenAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'OFFLINE',
        ),
        DeviceEntity(
          id: 'dev_103',
          hostname: 'SERVER-LOCAL-DB',
          os: 'Windows Server 2022',
          lastSeenAt: DateTime.now(),
          status: 'WARNING',
        ),
      ];

      emit(ClientDevicesLoaded(devices: mockDevices));

    } catch (e) {
      emit(const ClientDevicesError(
        message: 'Не удалось загрузить данные организации. Проверьте подключение к сети.',
      ));
    }
  }
}