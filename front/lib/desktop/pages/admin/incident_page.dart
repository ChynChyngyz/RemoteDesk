import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/incident/presentation/bloc/incident_cubit.dart';
import '../../../features/incident/presentation/bloc/incident_state.dart';

class IncidentPage extends StatefulWidget {
  final int orgId;
  const IncidentPage({super.key, required this.orgId});

  @override
  State<IncidentPage> createState() => _IncidentPageState();
}

class _IncidentPageState extends State<IncidentPage> {
  @override
  void initState() {
    super.initState();
    context.read<IncidentCubit>().fetchAll(widget.orgId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incidents"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<IncidentCubit>().fetchAll(widget.orgId),
          )
        ],
      ),
      body: BlocBuilder<IncidentCubit, IncidentState>(
        builder: (context, state) {
          if (state is IncidentLoading) return const Center(child: CircularProgressIndicator());
          if (state is IncidentError) return Center(child: Text(state.message));

          if (state is IncidentLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Id")),
                    DataColumn(label: Text("Device")),
                    DataColumn(label: Text("Rule")),
                    DataColumn(label: Text("Severity")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Opened At")),
                    DataColumn(label: Text("Resolved At")),
                    DataColumn(label: Text("Last Event At")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: state.items.map((item) => DataRow(
                      cells: [
                        DataCell(Text(item.id?.toString() ?? "")),
                        DataCell(Text(item.device.toString())),
                        DataCell(Text(item.rule.toString())),
                        DataCell(Text(item.severity.toString())),
                        DataCell(Text(item.status.toString())),
                        DataCell(Text(item.openedAt.toString())),
                        DataCell(Text(item.resolvedAt?.toString() ?? "")),
                        DataCell(Text(item.lastEventAt.toString())),
                        DataCell(
                          (item.status == "OPEN" || item.status == "open")
                              ? ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            onPressed: () {
                              context.read<IncidentCubit>().acknowledge(item.id!, widget.orgId);
                            },
                            child: const Text("Acknowledge"),
                          )
                              : const Text("—"),
                        ),
                      ]
                  )).toList(),
                ),
              ),
            );
          }
          return const Center(child: Text("Empty"));
        },
      ),
    );
  }
}