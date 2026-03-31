// desktop/pages/admin/admin_tickets_page.dart

import 'package:flutter/material.dart';
import 'package:front/core/network/dio_admin.dart';
import 'package:dio/dio.dart';
import 'package:front/core/errors/error_handler.dart';


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
      appBar: AppBar(
        title: const Text("Support Tickets"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadTickets,
            tooltip: "Refresh Tickets",
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: isLoadingTickets
                  ? const Center(child: CircularProgressIndicator())
                  : tickets.isEmpty
                  ? const Center(child: Text("No tickets found"))
                  : ListView.separated(
                itemCount: tickets.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  final isSelected = selectedTicket?["id"] == ticket["id"];

                  return ListTile(
                    selected: isSelected,
                    selectedTileColor: Colors.blue.shade50,
                    title: Text(
                      ticket["title"] ?? "No Title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text("Status: ${ticket["status"]} • Priority: ${ticket["priority"]}"),
                    onTap: () => selectTicket(ticket),
                  );
                },
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: selectedTicket == null
                ? const Center(
              child: Text(
                "Select a ticket to view details",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedTicket!["title"] ?? "",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            label: Text(selectedTicket!["status"] ?? ""),
                            backgroundColor: selectedTicket!["status"] == "open"
                                ? Colors.green.shade100
                                : Colors.grey.shade200,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        selectedTicket!["description"] ?? "No description",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                Expanded(
                  child: isLoadingComments
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
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
                            Text(
                              "User ID: ${comment["author"]}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 8),
                            Text(comment["body"] ?? ""),
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
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: "Write a reply...",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          onSubmitted: (_) => sendComment(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: sendComment,
                        icon: const Icon(Icons.send),
                        label: const Text("Reply"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}