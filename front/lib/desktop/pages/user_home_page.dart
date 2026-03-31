// desktop/pages/user_home_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/desktop/pages/remote_view_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:front/features/tickets/presentation/bloc/ticket_cubit.dart';
import 'package:front/features/tickets/presentation/bloc/ticket_state.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String deviceId = "Fetching...";
  final TextEditingController _commentController = TextEditingController();

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
      setState(() {
        deviceId = deviceIdentifier;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        deviceId = "Error";
      });
    }
  }

  void _handleConnect() {
    final remoteId = deviceId.trim();
    if (remoteId.isEmpty || remoteId == "Fetching...") return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RemoteSessionPage(
          remoteId: remoteId,
          isTechnician: false,
        ),
      ),
    );
  }

  void _createNewTicketDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: const Text("Create new ticket"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Header"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Description of the problem",
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialog),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
              onPressed: () {
                if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                  context.read<TicketCubit>().createTicket(
                    titleController.text,
                    descController.text,
                  );
                  Navigator.pop(contextDialog);
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("User Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TicketCubit, TicketState>(
            listenWhen: (previous, current) => previous.error != current.error && current.error != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            },
          ),
        ],
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.computer, size: 60, color: Colors.red[700]),
                          const SizedBox(height: 20),
                          const Text("Your Device ID", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(deviceId, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: deviceId));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ID copied")));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                              onPressed: _handleConnect,
                              child: const Text("Request Support"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 32, 32, 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: BlocBuilder<TicketCubit, TicketState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade200))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("My tickets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle, color: Colors.red),
                                        onPressed: _createNewTicketDialog,
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: state.isLoadingTickets
                                      ? const Center(child: CircularProgressIndicator())
                                      : ListView.separated(
                                    itemCount: state.tickets.length,
                                    separatorBuilder: (_, __) => const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final ticket = state.tickets[index];
                                      final isSelected = state.selectedTicket?.id == ticket.id;

                                      return ListTile(
                                        selected: isSelected,
                                        selectedTileColor: Colors.red.shade50,
                                        title: Text(
                                          ticket.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                                        ),
                                        subtitle: Text("Status: ${ticket.status}"),
                                        onTap: () {
                                          context.read<TicketCubit>().selectTicket(ticket);
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: state.selectedTicket == null
                              ? const Center(child: Text("Select a ticket to view", style: TextStyle(color: Colors.grey)))
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.selectedTicket!.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(state.selectedTicket!.description, style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              Expanded(
                                child: state.isLoadingComments
                                    ? const Center(child: CircularProgressIndicator())
                                    : ListView.builder(
                                  padding: const EdgeInsets.all(24),
                                  itemCount: state.comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = state.comments[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Author ID: ${comment.author}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text(comment.body),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _commentController,
                                        decoration: InputDecoration(
                                          hintText: "Write comment...",
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: Icon(Icons.send, color: Colors.red[700]),
                                      onPressed: () {
                                        final text = _commentController.text.trim();
                                        if (text.isNotEmpty) {
                                          context.read<TicketCubit>().addComment(text);
                                          _commentController.clear();
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}