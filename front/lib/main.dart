// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:front/core/di/service_locator.dart';

import 'package:front/core/network/dio_client.dart';

import 'package:front/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:front/features/tickets/data/repositories/ticket_repository_impl.dart';
import 'package:front/features/device/data/repositories/device_repository.dart';
import 'package:front/features/incident/data/repositories/incident_repository.dart';
import 'package:front/features/notification/data/repositories/notification_repository.dart';
import 'package:front/features/audit/data/repositories/audit_repository.dart';
import 'package:front/features/metric_sample/data/repositories/metric_sample_repository.dart';

import 'package:front/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:front/features/tickets/presentation/bloc/ticket_cubit.dart';
import 'package:front/features/device/presentation/bloc/device_cubit.dart';
import 'package:front/features/incident/presentation/bloc/incident_cubit.dart';
import 'package:front/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:front/features/audit/presentation/bloc/audit_cubit.dart';
import 'package:front/features/metric_sample/presentation/bloc/metric_sample_cubit.dart';
import 'package:front/features/client_portal/presentation/bloc/client_devices_bloc.dart';

import 'package:front/features/auth/presentation/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // setup();
  final authRepository = AuthRepositoryImpl(DioClient.dio);
  final ticketRepository = TicketRepositoryImpl(DioClient.dio);
  final deviceRepository = DeviceRepository(DioClient.dio);
  final incidentRepository = IncidentRepository(DioClient.dio);
  final notificationRepository = NotificationRepository(DioClient.dio);
  final auditRepository = AuditEventRepository(DioClient.dio);
  final metricRepository = MetricSampleRepository(DioClient.dio);

  runApp(MyApp(
    repositoryAuth: authRepository,
    repositoryTicket: ticketRepository,
    repositoryDevice: deviceRepository,
    repositoryIncident: incidentRepository,
    repositoryNotification: notificationRepository,
    repositoryAudit: auditRepository,
    repositoryMetric: metricRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl repositoryAuth;
  final TicketRepositoryImpl repositoryTicket;
  final DeviceRepository repositoryDevice;
  final IncidentRepository repositoryIncident;
  final NotificationRepository repositoryNotification;
  final AuditEventRepository repositoryAudit;
  final MetricSampleRepository repositoryMetric;

  const MyApp({
    super.key,
    required this.repositoryAuth,
    required this.repositoryTicket,
    required this.repositoryDevice,
    required this.repositoryIncident,
    required this.repositoryNotification,
    required this.repositoryAudit,
    required this.repositoryMetric,
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
        BlocProvider(
          create: (_) => DeviceCubit(repositoryDevice),
        ),
        BlocProvider(
          create: (_) => IncidentCubit(repositoryIncident),
        ),
        BlocProvider(
          create: (_) => NotificationCubit(repositoryNotification),
        ),
        BlocProvider(
          create: (_) => AuditEventCubit(repositoryAudit),
        ),
        BlocProvider(
          create: (_) => MetricSampleCubit(repositoryMetric),
        ),
        BlocProvider(
          create: (_) => ClientDevicesBloc()..add(const FetchClientDevices()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Remote Desktop',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade700,
            background: const Color(0xFFF4F7FC),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 1,
            shadowColor: Colors.black12,
            centerTitle: false,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          dataTableTheme: DataTableThemeData(
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.blue.withOpacity(0.08);
              }
              return Colors.white;
            }),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}