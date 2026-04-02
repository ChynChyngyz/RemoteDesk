import '../../data/models/audit_model.dart';

abstract class AuditEventState {}

class AuditEventInitial extends AuditEventState {}

class AuditEventLoading extends AuditEventState {}

class AuditEventLoaded extends AuditEventState {
  final List<AuditEventModel> items;
  AuditEventLoaded(this.items);
}

class AuditEventError extends AuditEventState {
  final String message;
  AuditEventError(this.message);
}
