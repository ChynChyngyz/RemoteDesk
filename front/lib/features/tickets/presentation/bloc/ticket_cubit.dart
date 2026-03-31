// features/tickets/presentation/bloc/ticket_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/tickets/domain/repositories/i_ticket_repository.dart';
import 'package:front/features/tickets/domain/entities/ticket.dart';
import 'package:front/features/tickets/domain/entities/ticket_comment.dart';
import 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final ITicketRepository repository;

  TicketCubit(this.repository) : super(TicketState());

  Future<void> loadTickets() async {
    emit(state.copyWith(isLoadingTickets: true, clearError: true));
    try {
      final tickets = await repository.getTickets();
      emit(state.copyWith(tickets: tickets, isLoadingTickets: false));
    } catch (e) {
      emit(state.copyWith(
          error: e.toString().replaceAll("Exception: ", ""),
          isLoadingTickets: false));
    }
  }

  Future<void> selectTicket(Ticket ticket) async {
    emit(state.copyWith(selectedTicket: ticket, comments: [], isLoadingComments: true));
    try {
      if (ticket.id != null) {
        final comments = await repository.getComments(ticket.id!);
        emit(state.copyWith(comments: comments, isLoadingComments: false));
      }
    } catch (e) {
      emit(state.copyWith(
          error: e.toString().replaceAll("Exception: ", ""),
          isLoadingComments: false));
    }
  }

  Future<void> createTicket(String title, String description) async {
    try {
      final newTicket = await repository.createTicket(title, description);
      final updatedTickets = List<Ticket>.from(state.tickets)..insert(0, newTicket);
      emit(state.copyWith(tickets: updatedTickets));
    } catch (e) {
      emit(state.copyWith(error: e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> addComment(String body) async {
    final ticketId = state.selectedTicket?.id;
    if (ticketId == null) return;

    try {
      final newComment = await repository.createComment(ticketId, body);
      final updatedComments = List<TicketComment>.from(state.comments)..add(newComment);
      emit(state.copyWith(comments: updatedComments));
    } catch (e) {
      emit(state.copyWith(error: e.toString().replaceAll("Exception: ", "")));
    }
  }
}