// desktop/pages/user_home_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:front/features/tickets/presentation/bloc/ticket_cubit.dart';
import 'package:front/features/tickets/presentation/bloc/ticket_state.dart';
import 'package:front/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:front/features/auth/presentation/bloc/auth_state.dart';
import 'package:front/core/theme/app_theme.dart';
import 'package:front/desktop/widgets/glass_panel.dart';
import 'package:front/desktop/widgets/nexus_sidebar.dart';
import 'package:front/desktop/pages/remote_view_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String deviceId = "Fetching...";
  final TextEditingController _commentController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    context.read<TicketCubit>().loadTickets();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceIdentifier = "Unknown";
    try {
      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        deviceIdentifier = webBrowserInfo.browserName.name;
      } else {
        if (Platform.isWindows) {
          WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
          deviceIdentifier = windowsInfo.computerName;
        } else if (Platform.isLinux) {
          LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
          deviceIdentifier = linuxInfo.name;
        }
      }
      if (!mounted) return;
      setState(() => deviceId = deviceIdentifier);
    } catch (e) {
      if (!mounted) return;
      setState(() => deviceId = "Error");
    }
  }

  void _handleConnect() async {
    final remoteId = deviceId.trim();
    if (remoteId.isEmpty || remoteId == "Fetching...") return;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final myJwtToken = authState.jwtToken;
      const sessionToken = "token_from_backend";
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RemoteSessionPage(
            remoteId: remoteId,
            sessionToken: sessionToken,
            jwtToken: myJwtToken,
            isTechnician: false,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User not authenticated")),
      );
    }
  }

  void _createNewTicketDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          backgroundColor: AppTheme.panelBg,
          title: const Text("Create New Ticket", style: TextStyle(color: AppTheme.textMain)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: AppTheme.textMain),
                  decoration: _inputDeco("Subject"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  maxLines: 4,
                  style: const TextStyle(color: AppTheme.textMain),
                  decoration: _inputDeco("Describe the problem..."),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppTheme.textMuted),
              onPressed: () => Navigator.pop(contextDialog),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                  context.read<TicketCubit>().createTicket(
                    titleController.text,
                    descController.text,
                  );
                  Navigator.pop(contextDialog);
                }
              },
              child: const Text("Create Ticket"),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.textMuted),
        filled: true,
        fillColor: AppTheme.bgDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.borderGlass),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.borderGlass),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary),
        ),
      );

  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildDevicesView();
      case 1:
        return _buildTicketsView();
      default:
        return _buildDevicesView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TicketCubit, TicketState>(
          listenWhen: (prev, curr) => prev.error != curr.error && curr.error != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.bgDark,
        body: Row(
          children: [
            NexusSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (i) => setState(() => _selectedIndex = i),
              items: [
                NexusSidebarItem(icon: Icons.computer_outlined, label: "My Devices"),
                NexusSidebarItem(icon: Icons.confirmation_number_outlined, label: "Support Tickets"),
              ],
            ),
            Expanded(child: _getPage()),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Tab 0: Devices View
  // ──────────────────────────────────────────────
  Widget _buildDevicesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Topbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.borderGlass)),
          ),
          child: Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Devices", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                  SizedBox(height: 4),
                  Text("Access your remote workstations securely with one click.", style: TextStyle(color: AppTheme.textMuted, fontSize: 15)),
                ],
              ),
              const Spacer(),
              // Device ID chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.computer, color: AppTheme.primary, size: 16),
                    const SizedBox(width: 8),
                    Text("This Device: $deviceId", style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: deviceId));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ID copied")));
                      },
                      child: const Icon(Icons.copy, size: 14, color: AppTheme.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Device Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 32,
                crossAxisSpacing: 32,
                childAspectRatio: 1.0,
              ),
              itemCount: 2, // mock until bloc wired
              itemBuilder: (context, index) {
                final isOnline = index == 0;
                return _buildDeviceCard(
                  hostname: index == 0 ? "Office Desktop" : "MacBook Pro",
                  subtitle: index == 0 ? "WS-092 • Windows 11" : "MBP-14 • macOS Sonoma",
                  isOnline: isOnline,
                  lastSeen: isOnline ? null : "2 hours ago",
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceCard({
    required String hostname,
    required String subtitle,
    required bool isOnline,
    String? lastSeen,
  }) {
    return GlassPanel(
      padding: const EdgeInsets.all(28),
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
                  color: isOnline ? AppTheme.success.withOpacity(0.1) : AppTheme.textMuted.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnline ? AppTheme.success : AppTheme.textMuted,
                        shape: BoxShape.circle,
                        boxShadow: isOnline ? [BoxShadow(color: AppTheme.success.withOpacity(0.5), blurRadius: 6)] : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOnline ? "Online" : "Offline",
                      style: TextStyle(
                        color: isOnline ? AppTheme.success : AppTheme.textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),
          Text(hostname, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.textMain)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: AppTheme.textMuted)),

          const Spacer(),

          if (!isOnline && lastSeen != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text("Last seen: $lastSeen", style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
            ),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: isOnline
                    ? const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark])
                    : null,
                color: isOnline ? null : AppTheme.panelBg,
                boxShadow: isOnline
                    ? [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
                    : null,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: isOnline ? Colors.white : AppTheme.textMuted,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isOnline ? _handleConnect : null,
                icon: Icon(isOnline ? Icons.bolt : Icons.power_off, size: 20),
                label: Text(isOnline ? "Connect Now" : "Wake Up", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  Tab 1: Tickets View
  // ──────────────────────────────────────────────
  Widget _buildTicketsView() {
    return BlocBuilder<TicketCubit, TicketState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Ticket List
            Container(
              width: 360,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: AppTheme.borderGlass)),
                color: Color(0x22000000),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Support Tickets", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: AppTheme.primary),
                          tooltip: "New Ticket",
                          onPressed: _createNewTicketDialog,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppTheme.borderGlass),
                  Expanded(
                    child: state.isLoadingTickets
                        ? const Center(child: CircularProgressIndicator())
                        : state.tickets.isEmpty
                            ? const Center(
                                child: Text("No tickets yet.\nTap + to create one.", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted)),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.tickets.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final ticket = state.tickets[index];
                                  final isSelected = state.selectedTicket?.id == ticket.id;
                                  return InkWell(
                                    onTap: () => context.read<TicketCubit>().selectTicket(ticket),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.panelBg,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected ? AppTheme.primary.withOpacity(0.4) : AppTheme.borderGlass,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  ticket.title,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                    color: AppTheme.textMain,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          _statusChip(ticket.status),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),

            // Right: Ticket Detail
            Expanded(
              child: state.selectedTicket == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined, size: 64, color: AppTheme.textMuted.withOpacity(0.3)),
                          const SizedBox(height: 16),
                          const Text("Select a ticket to view details", style: TextStyle(color: AppTheme.textMuted, fontSize: 16)),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ticket header
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppTheme.borderGlass)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.selectedTicket!.title,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _statusChip(state.selectedTicket!.status),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(state.selectedTicket!.description, style: const TextStyle(color: AppTheme.textMuted, fontSize: 16, height: 1.6)),
                            ],
                          ),
                        ),

                        // Comments
                        Expanded(
                          child: state.isLoadingComments
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  padding: const EdgeInsets.all(32),
                                  itemCount: state.comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = state.comments[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppTheme.panelBg,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppTheme.borderGlass),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.person_outline, color: AppTheme.textMuted, size: 16),
                                              const SizedBox(width: 6),
                                              Text("User ${comment.author}", style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(comment.body, style: const TextStyle(color: AppTheme.textMain, fontSize: 15, height: 1.5)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),

                        // Comment input
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: AppTheme.borderGlass)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  style: const TextStyle(color: AppTheme.textMain),
                                  decoration: _inputDeco("Write a comment..."),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.send, color: Colors.white),
                                  onPressed: () {
                                    final text = _commentController.text.trim();
                                    if (text.isNotEmpty) {
                                      context.read<TicketCubit>().addComment(text);
                                      _commentController.clear();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'open':
        color = AppTheme.primary;
        break;
      case 'in progress':
        color = AppTheme.warning;
        break;
      case 'closed':
        color = AppTheme.textMuted;
        break;
      default:
        color = AppTheme.textMuted;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}