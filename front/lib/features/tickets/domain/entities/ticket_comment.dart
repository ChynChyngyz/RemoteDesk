// features/tickets/domain/entities/ticket_comment.dart

class TicketComment {
  final int? id;
  final int author;
  final String body;
  final String createdAt;

  TicketComment({
    this.id,
    required this.author,
    required this.body,
    required this.createdAt,
  });
}