// desktop/pages/admin/admin_dashboard.dart

import 'package:flutter/material.dart';
import 'agent_token_page.dart';
import 'organization_page.dart';
import 'users_page.dart';
import 'admin_tickets_page.dart';

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
      OrganizationPage(orgId: widget.orgId),
      UsersPage(orgId: widget.orgId),
      const AgentTokenPage(),
      AdminTicketsPage(orgId: widget.orgId),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Row(
        children: [

          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (i){
              setState(() => index = i);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [

              NavigationRailDestination(
                icon: Icon(Icons.business),
                label: Text("Organization"),
              ),

              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text("Users"),
              ),

              NavigationRailDestination(
                icon: Icon(Icons.vpn_key),
                label: Text("Agent Token"),
              ),

              NavigationRailDestination(
                icon: Icon(Icons.confirmation_number),
                label: Text("Tickets"),
              ),

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