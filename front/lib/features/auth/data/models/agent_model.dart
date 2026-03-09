// features/auth/data/models/agent_model.dart

import 'package:front/features/auth/domain/entities/agent.dart';

class AgentModel extends Agent {
  AgentModel({
    required String phone,
    required String role,
    required String deviceId,
    required String hostname,
    required String organization,
    required String status,
  }) : super(
    phone: phone,
    role: role,
    deviceId: deviceId,
    hostname: hostname,
    organization: organization,
    status: status,
  );

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      deviceId: json['device_id']?.toString() ?? '',
      hostname: json['hostname'] ?? '',
      organization: json['organization'] ?? '',
      status: json['status'] ?? '',
    );
  }
}