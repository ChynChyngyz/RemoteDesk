// desktop/pages/remote_view_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:front/features/remote_session/data/services/webrtc_service.dart';

class RemoteSessionPage extends StatefulWidget {
  final String remoteId;
  final bool isTechnician;

  final String sessionToken;
  final String? jwtToken;
  final String? agentKey;

  const RemoteSessionPage({
    super.key,
    required this.remoteId,
    required this.isTechnician,
    required this.sessionToken,
    this.jwtToken,
    this.agentKey,
  });

  @override
  State<RemoteSessionPage> createState() => _RemoteSessionPageState();
}

class _RemoteSessionPageState extends State<RemoteSessionPage> {
  final RTCVideoRenderer _videoRenderer = RTCVideoRenderer();
  late WebRTCService webrtc;

  bool _isStreamReceived = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _videoRenderer.initialize();
    webrtc = WebRTCService(
      _videoRenderer,
      onStreamReceived: () {
        if (mounted) {
          setState(() {
            _isStreamReceived = true;
          });
        }
      },
    );

    await webrtc.connect(
      room: widget.remoteId,
      sessionToken: widget.sessionToken,
      jwt: widget.isTechnician ? null : widget.jwtToken,
      agentKey: widget.isTechnician ? widget.agentKey : null,
    );

    // if (!widget.isTechnician) {
    //   await webrtc.shareScreen();
    // }
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
      body: Stack(
        children: [
          Center(
            child: RTCVideoView(
              _videoRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
            ),
          ),

          if (!widget.isTechnician)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.screen_share),
                  label: const Text("Share My Screen"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12)
                  ),
                  onPressed: () {
                    webrtc.shareScreen();
                  },
                ),
              ),
            ),

          if (widget.isTechnician && !_isStreamReceived)
            const Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Waiting for user to share screen...",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
        ],
      ),
    );
  }
}