// desktop/pages/admin/organization_page.dart

import 'package:flutter/material.dart';
import 'package:front/core/network/dio_admin.dart';
import 'package:front/core/errors/error_handler.dart';
import 'package:dio/dio.dart';

class OrganizationPage extends StatefulWidget {

  final int orgId;

  const OrganizationPage({
    super.key,
    required this.orgId,
  });

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final industryController = TextEditingController();

  bool loading = false;
  bool loadingOrg = false;

  Map? organization;

  @override
  void initState() {
    super.initState();
    loadOrganization();
  }

  Future<void> loadOrganization() async {

    setState(() {
      loadingOrg = true;
    });

    try {

      final response = await DioAdmin.getOrganization(widget.orgId);

      setState(() {

        organization = response.data;

        nameController.text = organization?["name"] ?? "";
        cityController.text = organization?["city"] ?? "";
        industryController.text = organization?["industry"] ?? "";

      });

    } on DioException catch (e) {

      final message = ErrorHandler.parse(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

    }

    setState(() {
      loadingOrg = false;
    });

  }

  Future<void> createOrganization() async {

    if (nameController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name required")),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await DioAdmin.createOrganization(
        name: nameController.text,
        city: cityController.text,
        industry: industryController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Organization created")),
      );

      await loadOrganization();

    } on DioException catch (e) {

      final message = ErrorHandler.parse(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Create / Update Organization",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: 400,
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Organization Name",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: 400,
            child: TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: 400,
            child: TextField(
              controller: industryController,
              decoration: const InputDecoration(
                labelText: "Industry",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: loading ? null : createOrganization,
            child: loading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text("Save Organization"),
          ),

          const SizedBox(height: 40),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            "Current Organization",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          if (loadingOrg)
            const CircularProgressIndicator(),

          if (!loadingOrg && organization != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.business),

                title: Text(
                  organization!["name"] ?? "",
                ),

                subtitle: Text(
                  "${organization!["city"] ?? ""} • ${organization!["industry"] ?? ""}",
                ),

                trailing: Text(
                  organization!["is_active"] == true
                      ? "Active"
                      : "Inactive",
                  style: TextStyle(
                    color: organization!["is_active"] == true
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            )

        ],
      ),
    );
  }
}