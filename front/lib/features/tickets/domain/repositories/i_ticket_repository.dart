// features/tickets/domain/repositories/i_ticket_repository.dart

import 'package:front/features/tickets/domain/entities/ticket.dart';
import 'package:front/features/tickets/domain/entities/ticket_comment.dart';

abstract class ITicketRepository {
  Future<List<Ticket>> getTickets();
  Future<Ticket> createTicket(String title, String description);
  Future<List<TicketComment>> getComments(int ticketId);
  Future<TicketComment> createComment(int ticketId, String body);
}