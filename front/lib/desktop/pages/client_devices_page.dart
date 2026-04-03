// features/client_portal/presentation/pages/client_devices_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:front/features/client_portal/presentation/bloc/client_devices_bloc.dart';
import 'package:front/features/client_portal/domain/entities/device_entity.dart';

class ClientDevicesPage extends StatelessWidget {
  const ClientDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          "My Organization Devices",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: () {
              context.read<ClientDevicesBloc>().add(const FetchClientDevices());
            },
            tooltip: "Refresh List",
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<ClientDevicesBloc, ClientDevicesState>(
        builder: (context, state) {
          if (state is ClientDevicesLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }

          if (state is ClientDevicesError) {
            return _buildErrorState(context, state.message);
          }

          if (state is ClientDevicesLoaded) {
            if (state.devices.isEmpty) {
              return _buildEmptyState();
            }
            return _buildDevicesList(state.devices);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDevicesList(List<DeviceEntity> devices) {
    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: devices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final device = devices[index];
        return _DeviceCard(device: device);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.computer_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No devices found",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            "Your organization currently has no registered devices.",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<ClientDevicesBloc>().add(const FetchClientDevices()),
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
          )
        ],
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final DeviceEntity device;

  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    final bool isOnline = device.status.toUpperCase() == 'ONLINE';
    final bool isWarning = device.status.toUpperCase() == 'WARNING';

    final Color statusColor = isOnline
        ? Colors.green
        : (isWarning ? Colors.amber.shade700 : Colors.grey.shade600);

    final Color statusBgColor = isOnline
        ? Colors.green.shade50
        : (isWarning ? Colors.amber.shade50 : Colors.grey.shade100);

    return InkWell(
      onTap: () {
        // TODO: Переход на страницу деталей с графиками метрик (FR-040)
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.desktop_windows, color: Colors.blue.shade700),
            ),
            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.hostname,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    device.os,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        device.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  device.lastSeenAt != null
                      ? "Last seen: ${DateFormat('MMM dd, HH:mm').format(device.lastSeenAt!)}"
                      : "Never connected",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}