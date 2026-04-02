class MetricSampleModel {
  final int? id; final int device; final int cpuPct; final int ramPct; final int diskFreeGb; final int uptimeSec; final String ts;

  MetricSampleModel({
    this.id, required this.device, required this.cpuPct, required this.ramPct, required this.diskFreeGb, required this.uptimeSec, required this.ts
  });

  factory MetricSampleModel.fromJson(Map<String, dynamic> json) {
    return MetricSampleModel(
      id: json['id'], device: json['device'] ?? 0, cpuPct: json['cpu_pct'] ?? 0, ramPct: json['ram_pct'] ?? 0, diskFreeGb: json['disk_free_gb'] ?? 0, uptimeSec: json['uptime_sec'] ?? 0, ts: json['ts'] ?? '',
    );
  }
}
