import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/audit/presentation/bloc/audit_cubit.dart';
import '../../../features/audit/presentation/bloc/audit_state.dart';

class AuditEventPage extends StatefulWidget {
  final int orgId;
  const AuditEventPage({super.key, required this.orgId});

  @override
  State<AuditEventPage> createState() => _AuditEventPageState();
}

class _AuditEventPageState extends State<AuditEventPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuditEventCubit>().fetchAll(widget.orgId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AuditEvents")),
      body: BlocBuilder<AuditEventCubit, AuditEventState>(
        builder: (context, state) {
          if (state is AuditEventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuditEventLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Id")), DataColumn(label: Text("Type")), DataColumn(label: Text("Createdat"))
                  ],
                  rows: state.items.map((item) => DataRow(
                    cells: [
                      DataCell(Text(item.id?.toString() ?? "")), DataCell(Text(item.type.toString())), DataCell(Text(item.createdAt.toString()))
                    ]
                  )).toList(),
                ),
              ),
            );
          } else if (state is AuditEventError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Empty"));
        },
      ),
    );
  }
}
