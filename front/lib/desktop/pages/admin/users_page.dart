// desktop/pages/admin/users_page.dart

/// GET /org/users
/// POST /org/users
/// DELETE /org/users/{id}

import 'package:flutter/material.dart';
import 'package:front/core/network/dio_admin.dart';
import 'create_user_dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  List users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {

    final response = await DioAdmin.getUsers();

    setState(() {
      users = response.data;
    });
  }

  Future<void> deleteUser(int id) async {

    await DioAdmin.deleteUser(id);

    loadUsers();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Users"),
        actions: [

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {

              final created = await showDialog(
                context: context,
                builder: (_) => const CreateUserDialog(),
              );

              if(created == true){
                loadUsers();
              }

            },
          )

        ],
      ),

      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index){

          final user = users[index];

          return ListTile(

            leading: const Icon(Icons.person),

            title: Text(user["phone"]),

            subtitle: Text(user["role"]),

            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: (){
                deleteUser(user["id"]);
              },
            ),

          );
        },
      ),
    );
  }
}