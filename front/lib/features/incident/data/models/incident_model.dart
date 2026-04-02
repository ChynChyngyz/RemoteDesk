class IncidentModel {
  final int? id; final int device; final int rule; final String severity; final String status; final String openedAt; final String? resolvedAt; final String lastEventAt;

  IncidentModel({
    this.id, required this.device, required this.rule, required this.severity, required this.status, required this.openedAt, this.resolvedAt, required this.lastEventAt
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'], device: json['device'] is int ? json['device'] : (json['device'] is Map ? json['device']['id'] : 0), rule: json['rule'] is int ? json['rule'] : (json['rule'] is Map ? json['rule']['id'] : 0), severity: json['severity'] ?? '', status: json['status'] ?? '', openedAt: json['opened_at'] ?? '', resolvedAt: json['resolved_at'], lastEventAt: json['last_event_at'] ?? '',
    );
  }
}
