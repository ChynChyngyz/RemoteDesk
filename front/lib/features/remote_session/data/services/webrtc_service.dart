import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  final Map<String, dynamic> _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {
        'urls': 'turn:YOUR_SERVER_IP:3478',
        'username': 'user',
        'credential': 'password',
      },
    ],
    'sdpSemantics': 'unified-plan',
  };

  // Инициализация соединения
  Future<void> init() async {
    _peerConnection = await createPeerConnection(_configuration);

    // Слушаем изменения льда (ICE Candidates)
    _peerConnection!.onIceCandidate = (candidate) {
      // Здесь отправляем кандидатов в Django через WebSocket
    };
  }

  Future<MediaStream> captureScreen() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '1280',
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'optional': [],
      }
    };
    _localStream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
    return _localStream!;
  }

  void dispose() {
    _localStream?.dispose();
    _peerConnection?.dispose();
  }
}