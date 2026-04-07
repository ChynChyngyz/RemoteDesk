// desktop/pages/admin/metric_sample.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/metric_sample/presentation/bloc/metric_sample_cubit.dart';
import 'package:front/features/metric_sample/presentation/bloc/metric_sample_state.dart';

class MetricSamplePage extends StatefulWidget {
  final int orgId;
  const MetricSamplePage({super.key, required this.orgId});

  @override
  State<MetricSamplePage> createState() => _MetricSamplePageState();
}

class _MetricSamplePageState extends State<MetricSamplePage> {
  @override
  void initState() {
    super.initState();
    context.read<MetricSampleCubit>().fetchAll(widget.orgId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MetricSamples")),
      body: BlocBuilder<MetricSampleCubit, MetricSampleState>(
        builder: (context, state) {
          if (state is MetricSampleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MetricSampleLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Id")), DataColumn(label: Text("Device")), DataColumn(label: Text("Cpupct")), DataColumn(label: Text("Rampct")), DataColumn(label: Text("Diskfreegb")), DataColumn(label: Text("Uptimesec")), DataColumn(label: Text("Ts"))
                  ],
                  rows: state.items.map((item) => DataRow(
                    cells: [
                      DataCell(Text(item.id?.toString() ?? "")), DataCell(Text(item.device.toString())), DataCell(Text(item.cpuPct.toString())), DataCell(Text(item.ramPct.toString())), DataCell(Text(item.diskFreeGb.toString())), DataCell(Text(item.uptimeSec.toString())), DataCell(Text(item.ts.toString()))
                    ]
                  )).toList(),
                ),
              ),
            );
          } else if (state is MetricSampleError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Empty"));
        },
      ),
    );
  }
}
