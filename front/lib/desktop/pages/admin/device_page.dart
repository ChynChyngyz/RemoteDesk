// desktop/pages/admin/device_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/device/presentation/bloc/device_cubit.dart';
import 'package:front/features/device/presentation/bloc/device_state.dart';

class DevicePage extends StatefulWidget {
  final int orgId;
  const DevicePage({super.key, required this.orgId});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  void initState() {
    super.initState();
    context.read<DeviceCubit>().fetchAll(widget.orgId);
  }

  void _showCreateDialog() {
    final hostnameCtrl = TextEditingController();
    final serialCtrl = TextEditingController();
    final ipCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Manual Device"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: hostnameCtrl, decoration: const InputDecoration(labelText: "Hostname")),
            TextField(controller: serialCtrl, decoration: const InputDecoration(labelText: "Serial")),
            TextField(controller: ipCtrl, decoration: const InputDecoration(labelText: "IP Address")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              context.read<DeviceCubit>().create({
                "hostname": hostnameCtrl.text,
                "os": "Unknown", // Дефолтные значения
                "os_version": "Unknown",
                "serial": serialCtrl.text,
                "ip": ipCtrl.text,
                "status": "registered",
                "agent_version": "1.0.0",
              }, widget.orgId);
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devices"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showCreateDialog),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => context.read<DeviceCubit>().fetchAll(widget.orgId)),
        ],
      ),
      body: BlocBuilder<DeviceCubit, DeviceState>(
        builder: (context, state) {
          if (state is DeviceLoading) return const Center(child: CircularProgressIndicator());
          if (state is DeviceError) return Center(child: Text(state.message));

          if (state is DeviceLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Id")),
                    DataColumn(label: Text("Hostname")),
                    DataColumn(label: Text("OS")),
                    DataColumn(label: Text("Serial")),
                    DataColumn(label: Text("IP")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Last Seen")),
                  ],
                  rows: state.items.map((item) => DataRow(
                      cells: [
                        DataCell(Text(item.id?.toString() ?? "")),
                        DataCell(Text(item.hostname.toString())),
                        DataCell(Text(item.os.toString())),
                        DataCell(Text(item.serial.toString())),
                        DataCell(Text(item.ip.toString())),
                        DataCell(Text(item.status.toString())),
                        DataCell(Text(item.lastSeenAt?.toString() ?? "Never")),
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