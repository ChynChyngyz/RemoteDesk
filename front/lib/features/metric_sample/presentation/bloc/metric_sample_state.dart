import '../../data/models/metric_sample_model.dart';

abstract class MetricSampleState {}

class MetricSampleInitial extends MetricSampleState {}

class MetricSampleLoading extends MetricSampleState {}

class MetricSampleLoaded extends MetricSampleState {
  final List<MetricSampleModel> items;
  MetricSampleLoaded(this.items);
}

class MetricSampleError extends MetricSampleState {
  final String message;
  MetricSampleError(this.message);
}
