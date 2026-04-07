// desktop/pages/admin/notification_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:front/features/notification/presentation/bloc/notification_state.dart';


class NotificationPage extends StatefulWidget {
  final int orgId;
  const NotificationPage({super.key, required this.orgId});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchAll(widget.orgId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<NotificationCubit>().fetchAll(widget.orgId),
          )
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) return const Center(child: CircularProgressIndicator());
          if (state is NotificationError) return Center(child: Text(state.message));

          if (state is NotificationLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Id")),
                    DataColumn(label: Text("Type")),
                    DataColumn(label: Text("Created At")),
                    DataColumn(label: Text("Read At")),
                    DataColumn(label: Text("Actions")), 
                  ],
                  rows: state.items.map((item) => DataRow(
                      cells: [
                        DataCell(Text(item.id?.toString() ?? "")),
                        DataCell(Text(item.type.toString())),
                        DataCell(Text(item.createdAt.toString())),
                        DataCell(Text(item.readAt?.toString() ?? "Unread")),
                        DataCell(
                          item.readAt == null || item.readAt!.isEmpty
                              ? ElevatedButton(
                            onPressed: () {
                              context.read<NotificationCubit>().markAsRead(item.id!, widget.orgId);
                            },
                            child: const Text("Mark Read"),
                          )
                              : const Icon(Icons.check, color: Colors.green),
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