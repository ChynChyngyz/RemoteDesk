
import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {
  final String id;
  final String hostname;
  final String os;
  final DateTime? lastSeenAt;

  final String status;

  const DeviceEntity({
    required this.id,
    required this.hostname,
    required this.os,
    this.lastSeenAt,
    required this.status,
  });

  @override
  List<Object?> get props => [id, hostname, os, lastSeenAt, status];

  DeviceEntity copyWith({
    String? id,
    String? hostname,
    String? os,
    DateTime? lastSeenAt,
    String? status,
  }) {
    return DeviceEntity(
      id: id ?? this.id,
      hostname: hostname ?? this.hostname,
      os: os ?? this.os,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      status: status ?? this.status,
    );
  }
}