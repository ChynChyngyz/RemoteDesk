class AuditEventModel {
  final int? id; final String type; final Map<String, dynamic> metadataJson; final String createdAt;

  AuditEventModel({
    this.id, required this.type, required this.metadataJson, required this.createdAt
  });

  factory AuditEventModel.fromJson(Map<String, dynamic> json) {
    return AuditEventModel(
      id: json['id'], type: json['type'] ?? '', metadataJson: json['metadata_json'] ?? {}, createdAt: json['created_at'] ?? '',
    );
  }
}
