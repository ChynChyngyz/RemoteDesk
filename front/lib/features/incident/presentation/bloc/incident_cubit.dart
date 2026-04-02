import 'package:flutter_bloc/flutter_bloc.dart';
import 'incident_state.dart';
import '../../data/repositories/incident_repository.dart';

class IncidentCubit extends Cubit<IncidentState> {
  final IncidentRepository repository;

  IncidentCubit(this.repository) : super(IncidentInitial());

  Future<void> fetchAll(int orgId) async {
    emit(IncidentLoading());

    try {
      final items = await repository.getAll(orgId);
      emit(IncidentLoaded(items));
    } catch (e) {
      emit(IncidentError(e.toString()));
    }
  }

  Future<void> acknowledge(int incidentId, int orgId) async {
    try {
      await repository.acknowledgeIncident(incidentId);
      await fetchAll(orgId);
    } catch (e) {
      emit(IncidentError(e.toString()));
    }
  }
}