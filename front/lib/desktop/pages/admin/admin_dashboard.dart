// desktop/pages/admin/admin_dashboard.dart

import 'package:flutter/material.dart';
import 'admin_overview_page.dart';
import 'agent_token_page.dart';
import 'organization_page.dart';
import 'users_page.dart';
import 'admin_tickets_page.dart';
import 'device_page.dart';
import 'incident_page.dart';
import 'notification_page.dart';
import 'audit_page.dart';
import 'metric_sample_page.dart';
import 'package:front/desktop/widgets/nexus_sidebar.dart';
import 'package:front/core/theme/app_theme.dart';

class AdminDashboard extends StatefulWidget {
  final int orgId;

  const AdminDashboard({
    super.key,
    required this.orgId,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  int index = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const AdminOverviewPage(),
      OrganizationPage(orgId: widget.orgId),
      UsersPage(orgId: widget.orgId),
      const AgentTokenPage(),
      AdminTicketsPage(orgId: widget.orgId),
      DevicePage(orgId: widget.orgId),
      IncidentPage(orgId: widget.orgId),
      NotificationPage(orgId: widget.orgId),
      AuditEventPage(orgId: widget.orgId),
      MetricSamplePage(orgId: widget.orgId),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Row(
        children: [
          NexusSidebar(
            selectedIndex: index,
            onItemSelected: (i) {
              setState(() => index = i);
            },
            items: [
              NexusSidebarItem(icon: Icons.dashboard_outlined, label: "Overview"),
              NexusSidebarItem(icon: Icons.business, label: "Organization"),
              NexusSidebarItem(icon: Icons.people, label: "Users"),
              NexusSidebarItem(icon: Icons.vpn_key, label: "Agent Token"),
              NexusSidebarItem(icon: Icons.confirmation_number, label: "Tickets"),
              NexusSidebarItem(icon: Icons.devices, label: "Devices"),
              NexusSidebarItem(icon: Icons.warning, label: "Incidents"),
              NexusSidebarItem(icon: Icons.notifications, label: "Notifications"),
              NexusSidebarItem(icon: Icons.list_alt, label: "Audit"),
              NexusSidebarItem(icon: Icons.analytics, label: "Metrics"),
            ],
          ),
          Expanded(
            child: pages[index],
          )
        ],
      ),
    );
  }
}