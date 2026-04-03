// import 'package:front/features/remote_session/presentation/bloc/remote_assist_bloc.dart';
// import 'package:front/features/remote_session/domain/repositories/remote_assist_repository.dart';
// import 'package:front/features/remote_session/data/repositories/remote_assist_repository_impl.dart';
// import 'package:front/features/remote_session/data/datasources/signaling_datasource.dart';
// import 'package:front/features/remote_session/data/datasources/webrtc_datasource.dart';
// import 'package:get_it/get_it.dart';
//
// final sl = GetIt.instance;
//
// void setup() {
//   sl.registerLazySingleton<SignalingDataSource>(
//         () => SignalingDataSource(),
//   );
//
//   sl.registerLazySingleton<WebRTCDataSource>(
//         () => WebRTCDataSource(sl()),
//   );
//
//   sl.registerLazySingleton<RemoteAssistRepository>(
//         () => RemoteAssistRepositoryImpl(
//       signalingDataSource: sl(),
//       webRtcDataSource: sl(),
//     ),
//   );
//
//   sl.registerFactory<RemoteAssistBloc>(
//         () => RemoteAssistBloc(sl()),
//   );
// }