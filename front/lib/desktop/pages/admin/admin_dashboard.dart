// desktop/pages/admin/admin_dashboard.dart

import 'package:flutter/material.dart';
import 'agent_token_page.dart';
import 'organization_page.dart';
import 'users_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  int index = 0;

  final pages = const [
    OrganizationPage(),
    UsersPage(),
    AgentTokenPage(),
  ];

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

            ],
          ),

          Expanded(child: pages[index])

        ],
      ),

    );
  }
}