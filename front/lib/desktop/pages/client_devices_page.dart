// features/client_portal/presentation/pages/client_devices_page.dart

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:front/features/client_portal/presentation/bloc/client_devices_bloc.dart';
import 'package:front/features/client_portal/domain/entities/device_entity.dart';
import 'package:front/core/theme/app_theme.dart';
import 'package:front/desktop/widgets/glass_panel.dart';

class ClientDevicesPage extends StatelessWidget {
  const ClientDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text(
          "My Organization Devices",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textMain),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.textMuted),
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
    return GridView.builder(
      padding: const EdgeInsets.all(32.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 380,
        mainAxisSpacing: 32,
        crossAxisSpacing: 32,
        childAspectRatio: 0.85,
      ),
      itemCount: devices.length,
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

    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.desktop_windows, color: AppTheme.primary, size: 32),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                        boxShadow: isOnline ? [BoxShadow(color: statusColor.withOpacity(0.5), blurRadius: 4)] : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      device.status,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            device.hostname,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            device.os,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textMuted,
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              device.lastSeenAt != null
                  ? "Last seen: ${DateFormat('MMM dd, HH:mm').format(device.lastSeenAt!)}"
                  : "Never connected",
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isOnline ? () {} : null,
              icon: const Icon(Icons.bolt),
              label: const Text("Connect Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOnline ? null : AppTheme.panelBg,
                foregroundColor: isOnline ? null : AppTheme.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}