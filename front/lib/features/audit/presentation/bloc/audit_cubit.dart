import 'package:flutter_bloc/flutter_bloc.dart';
import 'audit_state.dart';
import '../../data/repositories/audit_repository.dart';

class AuditEventCubit extends Cubit<AuditEventState> {
  final AuditEventRepository repository;

  AuditEventCubit(this.repository) : super(AuditEventInitial());

  Future<void> fetchAll(int orgId) async {
    emit(AuditEventLoading());
    try {
      final items = await repository.getAll(orgId);
      emit(AuditEventLoaded(items));
    } catch (e) {
      emit(AuditEventError(e.toString()));
    }
  }
}
