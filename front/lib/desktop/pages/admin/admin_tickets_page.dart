// desktop/pages/admin/admin_tickets_page.dart

import 'package:flutter/material.dart';
import 'package:front/core/network/dio_admin.dart';
import 'package:dio/dio.dart';
import 'package:front/core/errors/error_handler.dart';
import 'package:front/core/theme/app_theme.dart';


class AdminTicketsPage extends StatefulWidget {
  final int orgId;

  const AdminTicketsPage({
    super.key,
    required this.orgId,
  });

  @override
  State<AdminTicketsPage> createState() => _AdminTicketsPageState();
}

class _AdminTicketsPageState extends State<AdminTicketsPage> {
  List tickets = [];
  Map? selectedTicket;
  List comments = [];
  bool isLoadingTickets = false;
  bool isLoadingComments = false;

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> loadTickets() async {
    setState(() => isLoadingTickets = true);
    try {
      final response = await DioAdmin.getTickets();
      setState(() {
        tickets = response.data;
      });
    } on DioException catch (e) {
      final message = ErrorHandler.parse(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
    setState(() => isLoadingTickets = false);
  }

  Future<void> selectTicket(Map ticket) async {
    setState(() {
      selectedTicket = ticket;
      isLoadingComments = true;
      comments = [];
    });

    try {
      final response = await DioAdmin.getTicketComments(ticket["id"]);
      setState(() {
        comments = response.data;
      });
    } on DioException catch (e) {
      final message = ErrorHandler.parse(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    setState(() => isLoadingComments = false);
  }

  Future<void> sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || selectedTicket == null) return;

    try {
      final response = await DioAdmin.createTicketComment(selectedTicket!["id"], text);
      setState(() {
        comments.add(response.data);
        _commentController.clear();
      });
    } on DioException catch (e) {
      final message = ErrorHandler.parse(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        title: const Text("Support Tickets", style: TextStyle(color: AppTheme.textMain)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.textMuted),
            onPressed: loadTickets,
            tooltip: "Refresh Tickets",
          )
        ],
      ),
      body: Row(
        children: [
          // Ticket list panel
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: AppTheme.borderGlass)),
              ),
              child: isLoadingTickets
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                  : tickets.isEmpty
                  ? const Center(
                      child: Text("No tickets found", style: TextStyle(color: AppTheme.textMuted)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: tickets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final ticket = tickets[index];
                        final isSelected = selectedTicket?["id"] == ticket["id"];

                        return InkWell(
                          onTap: () => selectTicket(ticket),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary.withOpacity(0.1)
                                  : AppTheme.panelBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primary.withOpacity(0.4)
                                    : AppTheme.borderGlass,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ticket["title"] ?? "No Title",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: AppTheme.textMain,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Status: ${ticket["status"]} • Priority: ${ticket["priority"]}",
                                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Ticket detail panel
          Expanded(
            flex: 2,
            child: selectedTicket == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: AppTheme.textMuted.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        const Text(
                          "Select a ticket to view details",
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppTheme.borderGlass)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedTicket!["title"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textMain,
                                    ),
                                  ),
                                ),
                                _statusChip(selectedTicket!["status"] ?? ""),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              selectedTicket!["description"] ?? "No description",
                              style: const TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.6),
                            ),
                          ],
                        ),
                      ),

                      // Comments list
                      Expanded(
                        child: isLoadingComments
                            ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                            : ListView.builder(
                                padding: const EdgeInsets.all(24),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
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
                                            Text(
                                              "User ID: ${comment["author"]}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primary,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          comment["body"] ?? "",
                                          style: const TextStyle(color: AppTheme.textMain, fontSize: 15, height: 1.5),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),

                      // Reply input
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: AppTheme.borderGlass)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                style: const TextStyle(color: AppTheme.textMain),
                                decoration: InputDecoration(
                                  hintText: "Write a reply...",
                                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                                  filled: true,
                                  fillColor: AppTheme.bgDark,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                ),
                                onSubmitted: (_) => sendComment(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton.icon(
                                onPressed: sendComment,
                                icon: const Icon(Icons.send),
                                label: const Text("Reply"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
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