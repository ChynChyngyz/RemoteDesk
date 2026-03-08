// features/remote_session/presentation/pages/remote_session_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RemoteSessionPage extends StatefulWidget {
  final String remoteId;
  final bool isTechnician; // Добавляем роль: техник или юзер

  const RemoteSessionPage({
    super.key,
    required this.remoteId,
    this.isTechnician = true, // По умолчанию считаем, что техник подключается к кому-то
  });

  @override
  State<RemoteSessionPage> createState() => _RemoteSessionPageState();
}

class _RemoteSessionPageState extends State<RemoteSessionPage> {
  // Рендерер для отображения видео
  final RTCVideoRenderer _videoRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _setupSession();
  }

  Future<void> _setupSession() async {
    // 1. Инициализируем рендерер
    await _videoRenderer.initialize();

    // 2. Здесь будет вызов Cubit для установки соединения через Django
    // context.read<RemoteSessionCubit>().startConnection(widget.remoteId);
  }

  @override
  void dispose() {
    _videoRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Session: ${widget.remoteId}"),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.red),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Stack(
        children: [
          // Основное окно видео
          Center(
            child: RTCVideoView(
              _videoRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
            ),
          ),

          // Оверлей с информацией
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                widget.isTechnician ? "Viewing: ${widget.remoteId}" : "Sharing Screen...",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}