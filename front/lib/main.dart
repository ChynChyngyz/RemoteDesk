// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:front/core/network/dio_client.dart';
import 'package:front/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:front/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:front/features/auth/presentation/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = AuthRepositoryImpl(DioClient.dio);
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Remote Desktop App',
        theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
