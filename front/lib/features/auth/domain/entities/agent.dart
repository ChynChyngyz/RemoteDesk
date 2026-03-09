// features/auth/domain/entities/agent.dart


class Agent {
  final String role;
  final String deviceId;
  final String hostname;
  final String organization;
  final String status;

  Agent({
    required String phone,
    required this.role,
    required this.deviceId,
    required this.hostname,
    required this.organization,
    required this.status,
  });
}