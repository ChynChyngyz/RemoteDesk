// desktop/pages/agent_home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/desktop/pages/remote_view_page.dart';
import 'package:front/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:front/features/auth/presentation/bloc/auth_state.dart';
import 'package:front/features/auth/presentation/pages/login_page.dart';
import 'package:front/core/theme/app_theme.dart';
import 'package:front/desktop/widgets/glass_panel.dart';
import 'package:front/desktop/widgets/nexus_sidebar.dart';


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
      backgroundColor: AppTheme.bgDark,
      body: Row(
        children: [
          NexusSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            onLogout: () {
              context.read<AuthCubit>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            items: [
              NexusSidebarItem(icon: Icons.home_outlined, label: "Home"),
              NexusSidebarItem(icon: Icons.history_outlined, label: "History"),
              NexusSidebarItem(icon: Icons.settings_outlined, label: "Settings"),
            ],
          ),
          Expanded(child: _getPageContent()),
        ],
      ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Queue
        Container(
          width: 340,
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: AppTheme.borderGlass)),
            color: Color(0x33000000), // slight dark tint for column
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "Assigned Tickets",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildTicketMock("TCK-402", "BSOD Loop on Startup", "Michael Chang", true),
                    const SizedBox(height: 16),
                    _buildTicketMock("TCK-405", "Cannot access shared drive", "Lisa Ray", false),
                  ],
                ),
              ),
              // This Desk ID card (moved to bottom of queue)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Your Tech ID", style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(myId, style: const TextStyle(fontSize: 20, color: AppTheme.textMain, fontWeight: FontWeight.w300)),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: myId));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ID copied")));
                            },
                            child: const Icon(Icons.copy, color: AppTheme.primary, size: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        // Right Console
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppTheme.borderGlass))
                ),
                child: Row(
                  children: [
                    const Text(
                      "Live Session Console",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          const Text("Ready", style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 500,
                    child: GlassPanel(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.cast_connected, color: AppTheme.purple, size: 32),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            "Connect to Remote Desk",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                          ),
                          const SizedBox(height: 8),
                          const Text("Enter the unique ID of the client device to establish a secure connection.", style: TextStyle(color: AppTheme.textMuted)),
                          const SizedBox(height: 48),
                          TextField(
                            controller: _remoteIdController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: AppTheme.textMain, fontSize: 18),
                            decoration: InputDecoration(
                              hintText: "E.g. 1 234 567 890",
                              hintStyle: const TextStyle(color: AppTheme.textMuted),
                              filled: true,
                              fillColor: AppTheme.bgDark.withOpacity(0.5),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppTheme.borderGlass),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppTheme.borderGlass),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppTheme.purple),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(colors: [AppTheme.purple, Color(0xFFD8B4FE)]),
                                boxShadow: [BoxShadow(color: AppTheme.purple.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))]
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: _handleConnect,
                                icon: const Icon(Icons.bolt, size: 24),
                                label: const Text("Initialize Connection", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketMock(String id, String title, String user, bool isUrgent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.panelBg,
        border: Border.all(color: isUrgent ? AppTheme.primary : AppTheme.borderGlass),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isUrgent ? [BoxShadow(color: AppTheme.primary.withOpacity(0.1), blurRadius: 12)] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isUrgent ? AppTheme.danger.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  isUrgent ? "Urgent" : "Normal", 
                  style: TextStyle(color: isUrgent ? AppTheme.danger : AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.bold)
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: AppTheme.textMuted),
              const SizedBox(width: 4),
              Text(user, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isUrgent ? AppTheme.primaryDark : AppTheme.panelBg,
                foregroundColor: isUrgent ? Colors.white : AppTheme.textMain,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {},
              child: Text(isUrgent ? "Connect" : "Review"),
            ),
          )
        ],
      ),
    );
  }

void _handleConnect() async {
    final remoteId = _remoteIdController.text.trim();
    if (remoteId.isEmpty) return;

    final authState = context.read<AuthCubit>().state;

    if (authState is AuthAgentAuthenticated) {
      final myAgentKey = authState.agentKey;

      final sessionToken = "token_from_backend";

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RemoteSessionPage(
            remoteId: remoteId,
            sessionToken: sessionToken,
            agentKey: myAgentKey,
            isTechnician: true,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Agent not authenticated")),
      );
    }
  }


}