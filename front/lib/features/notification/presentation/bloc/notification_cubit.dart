import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';
import '../../data/repositories/notification_repository.dart';


class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationInitial());

  Future<void> fetchAll(int orgId) async {
    emit(NotificationLoading());
    try {
      final items = await repository.getAll(orgId);
      emit(NotificationLoaded(items));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(int notificationId, int orgId) async {
    try {
      await repository.markAsRead(notificationId);
      await fetchAll(orgId);
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}