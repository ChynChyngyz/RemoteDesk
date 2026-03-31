// features/tickets/data/repositories/ticket_repository_impl.dart

import 'package:dio/dio.dart';
import 'package:front/core/errors/error_handler.dart';
import 'package:front/features/tickets/domain/entities/ticket.dart';
import 'package:front/features/tickets/domain/entities/ticket_comment.dart';
import 'package:front/features/tickets/domain/repositories/i_ticket_repository.dart';
import 'package:front/features/tickets/data/models/ticket_model.dart';
import 'package:front/features/tickets/data/models/ticket_comment_model.dart';

class TicketRepositoryImpl implements ITicketRepository {
  final Dio _dio;

  TicketRepositoryImpl(this._dio);

  @override
  Future<List<Ticket>> getTickets() async {
    try {
      final response = await _dio.get("orgs/tickets/");
      return (response.data as List)
          .map((json) => TicketModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(ErrorHandler.parse(e));
    }
  }

  @override
  Future<Ticket> createTicket(String title, String description) async {
    try {
      final response = await _dio.post(
        "orgs/tickets/",
        data: {
          "title": title,
          "description": description,
          "priority": "medium",
          "status": "open"
        },
      );
      return TicketModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(ErrorHandler.parse(e));
    }
  }

  @override
  Future<List<TicketComment>> getComments(int ticketId) async {
    try {
      final response = await _dio.get("orgs/tickets/$ticketId/comments/");
      return (response.data as List)
          .map((json) => TicketCommentModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(ErrorHandler.parse(e));
    }
  }

  @override
  Future<TicketComment> createComment(int ticketId, String body) async {
    try {
      final response = await _dio.post(
        "orgs/tickets/$ticketId/comments/",
        data: {"body": body},
      );
      return TicketCommentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(ErrorHandler.parse(e));
    }
  }
}