class DeviceModel {
  final int? id; final String hostname; final String os; final String osVersion; final String serial; final String ip; final String status; final String agentVersion; final String? lastSeenAt;

  DeviceModel({
    this.id, required this.hostname, required this.os, required this.osVersion, required this.serial, required this.ip, required this.status, required this.agentVersion, this.lastSeenAt
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'], hostname: json['hostname'] ?? '', os: json['os'] ?? '', osVersion: json['os_version'] ?? '', serial: json['serial'] ?? '', ip: json['ip'] ?? '', status: json['status'] ?? '', agentVersion: json['agent_version'] ?? '', lastSeenAt: json['last_seen_at'],
    );
  }
}
