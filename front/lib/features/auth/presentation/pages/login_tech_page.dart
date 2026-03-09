// features/auth/presentation/pages/login_tech_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:front/features/auth/presentation/bloc/auth_state.dart';
import 'package:front/features/auth/presentation/pages/login_page.dart';
import 'package:front/desktop/pages/agent_home_page.dart';

class LoginTechPage extends StatefulWidget {
  const LoginTechPage({super.key});

  @override
  State<LoginTechPage> createState() => _LoginTechPageState();
}

class _LoginTechPageState extends State<LoginTechPage> {
  final TextEditingController _hashTokenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _hashTokenController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AuthCubit>().loginWithToken(
      _hashTokenController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is AuthAgentAuthenticated) {
          if (state.role == "Technician") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AnyDeskPage(),
              ),
            );
          }
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Center(
          child: Container(
            width: 420,
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
                Icon(Icons.lock, size: 50, color: Colors.red[700]),
                const SizedBox(height: 20),
                const Text(
                  "Technician Login",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _hashTokenController,
                  decoration: InputDecoration(
                    labelText: "Hash Token",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                        : const Text(
                      "Login",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text("Client? Login here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}