// features/tickets/data/models/ticket_comment_model.dart

import 'package:front/features/tickets/domain/entities/ticket_comment.dart';

class TicketCommentModel extends TicketComment {
  TicketCommentModel({
    super.id,
    required super.author,
    required super.body,
    required super.createdAt,
  });

  factory TicketCommentModel.fromJson(Map<String, dynamic> json) {
    return TicketCommentModel(
      id: json['id'],
      author: json['author'],
      body: json['body'],
      createdAt: json['created_at'],
    );
  }
}