import 'package:flutter_bloc/flutter_bloc.dart';
import 'metric_sample_state.dart';
import '../../data/repositories/metric_sample_repository.dart';

class MetricSampleCubit extends Cubit<MetricSampleState> {
  final MetricSampleRepository repository;

  MetricSampleCubit(this.repository) : super(MetricSampleInitial());

  Future<void> fetchAll(int orgId) async {
    emit(MetricSampleLoading());
    try {
      final items = await repository.getAll(orgId);
      emit(MetricSampleLoaded(items));
    } catch (e) {
      emit(MetricSampleError(e.toString()));
    }
  }
}
