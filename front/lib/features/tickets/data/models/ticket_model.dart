// features/tickets/data/models/ticket_model.dart

import 'package:front/features/tickets/domain/entities/ticket.dart';

class TicketModel extends Ticket {
  TicketModel({
    super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.priority,
    required super.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      createdAt: json['created_at'],
    );
  }
}