// features/tickets/presentation/bloc/ticket_state.dart

import 'package:front/features/tickets/domain/entities/ticket.dart';
import 'package:front/features/tickets/domain/entities/ticket_comment.dart';

class TicketState {
  final List<Ticket> tickets;
  final bool isLoadingTickets;
  final Ticket? selectedTicket;
  final List<TicketComment> comments;
  final bool isLoadingComments;
  final String? error;

  TicketState({
    this.tickets = const [],
    this.isLoadingTickets = false,
    this.selectedTicket,
    this.comments = const [],
    this.isLoadingComments = false,
    this.error,
  });

  TicketState copyWith({
    List<Ticket>? tickets,
    bool? isLoadingTickets,
    Ticket? selectedTicket,
    List<TicketComment>? comments,
    bool? isLoadingComments,
    String? error,
    bool clearError = false,
  }) {
    return TicketState(
      tickets: tickets ?? this.tickets,
      isLoadingTickets: isLoadingTickets ?? this.isLoadingTickets,
      selectedTicket: selectedTicket ?? this.selectedTicket,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      error: clearError ? null : (error ?? this.error),
    );
  }
}