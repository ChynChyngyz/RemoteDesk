// desktop/pages/admin/admin_overview_page.dart

import 'package:flutter/material.dart';
import 'package:front/core/theme/app_theme.dart';
import 'package:front/desktop/widgets/glass_panel.dart';

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "System Overview",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textMain),
          ),
          const SizedBox(height: 32),
          
          // Dashboard Stat Grid
          Row(
            children: [
              Expanded(child: _buildStatCard("Active Sessions", "14", AppTheme.success, Icons.hub)),
              const SizedBox(width: 32),
              Expanded(child: _buildStatCard("Total Devices", "1,248", AppTheme.primary, Icons.computer)),
              const SizedBox(width: 32),
              Expanded(child: _buildStatCard("System Events", "3", AppTheme.warning, Icons.warning_amber)),
            ],
          ),
          
          const SizedBox(height: 48),
          
          // Live Sessions Table
          const Text(
            "Live Connection Logs",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textMain),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GlassPanel(
              padding: const EdgeInsets.all(0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView(
                  children: [
                    _buildTableHeader(),
                    _buildTableRow("SES-9012", "Tech: Michael", "Client: 123 456 789", "Active", "0h 42m"),
                    _buildTableRow("SES-9011", "Tech: Lisa", "Client: 987 654 321", "Active", "1h 15m"),
                    _buildTableRow("SES-9010", "System", "Offline maint.", "Ended", "0h 10m", isEnded: true),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 16)),
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(color: AppTheme.textMain, fontSize: 36, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0x33000000),
        border: Border(bottom: BorderSide(color: AppTheme.borderGlass)),
      ),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text("Session ID", style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text("Operator", style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text("Target", style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Status", style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Duration", style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTableRow(String id, String op, String target, String status, String duration, {bool isEnded = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderGlass)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(id, style: const TextStyle(color: AppTheme.textMain))),
          Expanded(flex: 3, child: Text(op, style: const TextStyle(color: AppTheme.textMain))),
          Expanded(flex: 3, child: Text(target, style: const TextStyle(color: AppTheme.textMain))),
          Expanded(flex: 2, child: Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: isEnded ? AppTheme.textMuted : AppTheme.success, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(status, style: TextStyle(color: isEnded ? AppTheme.textMuted : AppTheme.success, fontWeight: FontWeight.bold)),
            ],
          )),
          Expanded(flex: 2, child: Text(duration, style: const TextStyle(color: AppTheme.textMuted))),
        ],
      ),
    );
  }
}
