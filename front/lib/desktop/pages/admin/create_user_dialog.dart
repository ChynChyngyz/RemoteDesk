// desktop/pages/admin/create_user_dialog.dart


import 'package:flutter/material.dart';
import 'package:front/core/network/dio_admin.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String role = "ClientViewer";

  Future<void> createUser() async {

    await DioAdmin.createUser(
      phone: phoneController.text,
      password: passwordController.text,
      role: role,
      organization: 3,
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text("Create User"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: "Phone"),
          ),

          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: "Password"),
          ),

          const SizedBox(height: 10),

          DropdownButton<String>(
            value: role,
            items: const [

              DropdownMenuItem(
                value: "ClientViewer",
                child: Text("ClientViewer"),
              ),

              DropdownMenuItem(
                value: "Technician",
                child: Text("Technician"),
              ),

            ],
            onChanged: (value){
              setState(() => role = value!);
            },
          )

        ],
      ),

      actions: [

        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: createUser,
          child: const Text("Create"),
        )

      ],

    );
  }
}