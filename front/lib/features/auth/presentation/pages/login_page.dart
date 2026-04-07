// features/auth/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:front/features/auth/presentation/bloc/auth_state.dart';
import 'package:front/features/auth/presentation/pages/login_tech_page.dart';
import 'package:front/desktop/pages/admin/admin_dashboard.dart';
import 'package:front/desktop/pages/user_home_page.dart';
import 'package:front/core/theme/app_theme.dart';
import 'package:front/desktop/widgets/glass_panel.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AuthCubit>().login(
      _phoneController.text.trim(),
      _passwordController.text.trim(),
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

        if (state is AuthAuthenticated) {

          final role = state.user.role;

          if (role == "OrgAdmin") {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AdminDashboard(
                  orgId: state.user.organization,
                ),
              ),
            );

          } else if (role == "ClientViewer") {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const UserHomePage(),
              ),
            );

          } else {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Unknown role")),
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
                Color(0xFF161A2B),
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
                        colors: [AppTheme.primary, AppTheme.primaryDark],
                      ).createShader(bounds),
                      child: const Icon(Icons.hub, size: 64, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Client Nexus",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Sign in to access your devices",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 48),

                    TextField(
                      controller: _phoneController,
                      style: const TextStyle(color: AppTheme.textMain),
                      decoration: InputDecoration(
                        labelText: "Phone",
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
                          borderSide: const BorderSide(color: AppTheme.primary),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: AppTheme.textMain),
                      decoration: InputDecoration(
                        labelText: "Password",
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
                          borderSide: const BorderSide(color: AppTheme.primary),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.textMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
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
                            colors: [AppTheme.primary, AppTheme.primaryDark],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.3),
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
                            pageBuilder: (context, anim1, anim2) => const LoginTechPage(),
                            transitionsBuilder: (context, anim1, anim2, child) {
                              return FadeTransition(opacity: anim1, child: child);
                            },
                          ),
                        );
                      },
                      child: const Text("Technician? Access Console"),
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
