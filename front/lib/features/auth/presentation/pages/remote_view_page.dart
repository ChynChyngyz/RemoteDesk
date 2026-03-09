// features/remote_session/presentation/pages/remote_view_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:front/features/remote_session/data/services/webrtc_service.dart';


class RemoteSessionPage extends StatefulWidget {
  final String remoteId;
  final bool isTechnician;

  const RemoteSessionPage({super.key, required this.remoteId, required this.isTechnician});

  @override
  State<RemoteSessionPage> createState() => _RemoteSessionPageState();
}

class _RemoteSessionPageState extends State<RemoteSessionPage> {
  final RTCVideoRenderer _videoRenderer = RTCVideoRenderer();
  late WebRTCService webrtc;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _videoRenderer.initialize();
    webrtc = WebRTCService(_videoRenderer);
    await webrtc.connect(widget.remoteId);
    if (!widget.isTechnician) {
      await webrtc.shareScreen();
    }
  }

  @override
  void dispose() {
    _videoRenderer.dispose();
    webrtc.dispose();
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
      body: Center(
        child: RTCVideoView(
          _videoRenderer,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
        ),
      ),
    );
  }
}