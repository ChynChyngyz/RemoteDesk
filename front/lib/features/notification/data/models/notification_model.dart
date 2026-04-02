class NotificationModel {
  final int? id; final String type; final Map<String, dynamic> payloadJson; final String? readAt; final String createdAt;

  NotificationModel({
    this.id, required this.type, required this.payloadJson, this.readAt, required this.createdAt
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'], type: json['type'] ?? '', payloadJson: json['payload_json'] ?? {}, readAt: json['read_at'], createdAt: json['created_at'] ?? '',
    );
  }
}
