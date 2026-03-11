// desktop/pages/admin/organization_page.dart

/// POST /org/create
/// GET /org/{id}
/// PUT /org/{id}


import 'package:flutter/material.dart';
import 'package:front/core/network/dio_admin.dart';
import 'package:front/core/errors/error_handler.dart';
import 'package:dio/dio.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final industryController = TextEditingController();

  bool loading = false;

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

      nameController.clear();
      cityController.clear();
      industryController.clear();
    } on DioException catch (e) {
      // Используем ErrorHandler для получения читаемой ошибки
      final message = ErrorHandler.parse(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: $e")),
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
            "Create Organization",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                : const Text("Create Organization"),
          ),
        ],
      ),
    );
  }
}