// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:front/core/network/dio_client.dart';

import 'package:front/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:front/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:front/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:front/features/auth/presentation/pages/login_page.dart';

import 'package:front/features/tickets/presentation/bloc/ticket_cubit.dart';
import 'package:front/features/tickets/data/repositories/ticket_repository_impl.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepository = AuthRepositoryImpl(DioClient.dio);
  final ticketRepository = TicketRepositoryImpl(DioClient.dio);
  runApp(MyApp(repositoryAuth: authRepository, repositoryTicket: ticketRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl repositoryAuth;
  final TicketRepositoryImpl repositoryTicket;

  const MyApp({
    super.key,
    required this.repositoryAuth,
    required this.repositoryTicket
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(repositoryAuth),
        ),

        BlocProvider(
          create: (_) => TicketCubit(repositoryTicket),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Remote Desktop',
        home: const LoginPage(),
      ),
    );
  }
}
