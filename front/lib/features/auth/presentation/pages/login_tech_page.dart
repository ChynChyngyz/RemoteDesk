// features/auth/presentation/pages/login_tech_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:front/features/auth/presentation/bloc/auth_state.dart';
import 'package:front/features/auth/presentation/pages/login_page.dart';
import 'package:front/desktop/pages/agent_home_page.dart';
import 'package:front/core/theme/app_theme.dart';
import 'package:front/desktop/widgets/glass_panel.dart';

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
        backgroundColor: AppTheme.bgDark,
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.5,
              colors: [
                Color(0xFF1B162B), // Dark purplish tint
                AppTheme.bgDark,
              ],
            ),
          ),
          child: Center(
            child: GlassPanel(
              padding: const EdgeInsets.all(48),
              child: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppTheme.purple, Color(0xFFD8B4FE)],
                      ).createShader(bounds),
                      child: const Icon(Icons.hub_outlined, size: 64, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Technician Console",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Authenticate active sessions",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 48),

                    TextField(
                      controller: _hashTokenController,
                      style: const TextStyle(color: AppTheme.textMain),
                      decoration: InputDecoration(
                        labelText: "Hash Token",
                        labelStyle: const TextStyle(color: AppTheme.textMuted),
                        filled: true,
                        fillColor: AppTheme.bgDark.withOpacity(0.5),
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

                    const SizedBox(height: 48),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [AppTheme.purple, Color(0xFFD8B4FE)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.purple.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            )
                          ]
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: AppTheme.textMuted),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, anim1, anim2) => const LoginPage(),
                            transitionsBuilder: (context, anim1, anim2, child) {
                              return FadeTransition(opacity: anim1, child: child);
                            },
                          ),
                        );
                      },
                      child: const Text("Client? Access Portal"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}