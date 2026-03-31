// features/tickets/domain/entities/ticket.dart

class Ticket {
  final int? id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String createdAt;

  Ticket({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
  });
}