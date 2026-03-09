// desktop/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/features/auth/presentation/pages/remote_view_page.dart';

class AnyDeskPage extends StatefulWidget {
  const AnyDeskPage({super.key});

  @override
  State<AnyDeskPage> createState() => _AnyDeskPageState();
}

class _AnyDeskPageState extends State<AnyDeskPage> {
  int _selectedIndex = 0;
  final TextEditingController _remoteIdController = TextEditingController();
  final String myId = "1 234 567 890";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Row(
        children: [
          _buildNavigationRail(),
          Expanded(child: _getPageContent()),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      backgroundColor: const Color(0xFF2E2E2E),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      labelType: NavigationRailLabelType.none,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Icon(Icons.monitor, color: Colors.red[700], size: 40),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined, color: Colors.white70),
          selectedIcon: Icon(Icons.home, color: Colors.white),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.history_outlined, color: Colors.white70),
          selectedIcon: Icon(Icons.history, color: Colors.white),
          label: Text('History'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined, color: Colors.white70),
          selectedIcon: Icon(Icons.settings, color: Colors.white),
          label: Text('Settings'),
        ),
      ],
    );
  }

  Widget _getPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildMainContent();
      case 1:
        return const Center(child: Text("History Page", style: TextStyle(fontSize: 24)));
      case 2:
        return const Center(child: Text("Settings Page", style: TextStyle(fontSize: 24)));
      default:
        return Container();
    }
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          color: Colors.white,
          child: Row(
            children: [
              const Text(
                "New Connection",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Icon(Icons.shield, color: Colors.green[600], size: 20),
              const SizedBox(width: 10),
              const Text("Workstation is ready"),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: "This Desk",
                    subtitle: "Your address for remote connections",
                    color: Colors.red[700]!,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              myId,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: myId));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("ID copied to clipboard")),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text("Password protected", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildInfoCard(
                    title: "Remote Desk",
                    subtitle: "Enter the ID of the remote device",
                    color: Colors.grey[800]!,
                    content: Column(
                      children: [
                        TextField(
                          controller: _remoteIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Remote Address",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.arrow_forward),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _handleConnect,
                            child: const Text("Connect"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleConnect() {
    final remoteId = _remoteIdController.text.trim();
    if (remoteId.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RemoteSessionPage(
          remoteId: "test",
          isTechnician: false,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required Color color,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 25),
          content,
        ],
      ),
    );
  }
}