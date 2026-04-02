import '../../data/models/incident_model.dart';

abstract class IncidentState {}

class IncidentInitial extends IncidentState {}

class IncidentLoading extends IncidentState {}

class IncidentLoaded extends IncidentState {
  final List<IncidentModel> items;
  IncidentLoaded(this.items);
}

class IncidentError extends IncidentState {
  final String message;
  IncidentError(this.message);
}
