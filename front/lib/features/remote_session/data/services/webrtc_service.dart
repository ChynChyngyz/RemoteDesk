// features/auth/remote_session/data/services/webrtc_service.dart

import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  late WebSocketChannel _channel;
  final RTCVideoRenderer remoteRenderer;

  WebRTCService(this.remoteRenderer);

  final Map<String, dynamic> _config = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
      {'urls': 'stun:stun2.l.google.com:19302'},
      // {'urls': 'turn:stun.l.google.com:19302'},
      // {},
      // {},
    ]
  };

  Future<void> connect(String room) async {
    _channel = WebSocketChannel.connect(Uri.parse("ws://localhost:8000/ws/signal/$room/"));

    _peerConnection = await createPeerConnection(_config);

    await _peerConnection!.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
    );

    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate != null) {
        _channel.sink.add(jsonEncode({"type": "candidate", "candidate": candidate.toMap()}));
      }
    };

    _peerConnection!.onTrack = (event) {
      remoteRenderer.srcObject = event.streams[0];
    };

    _channel.stream.listen((message) async {
      final data = jsonDecode(message);
      switch (data["type"]) {
        case "offer":
          await _peerConnection!.setRemoteDescription(RTCSessionDescription(data["sdp"], "offer"));
          final answer = await _peerConnection!.createAnswer();
          await _peerConnection!.setLocalDescription(answer);
          _channel.sink.add(jsonEncode({"type": "answer", "sdp": answer.sdp}));
          break;
        case "answer":
          await _peerConnection!.setRemoteDescription(RTCSessionDescription(data["sdp"], "answer"));
          break;
        case "candidate":
          await _peerConnection!.addCandidate(RTCIceCandidate(
            data["candidate"]["candidate"],
            data["candidate"]["sdpMid"],
            data["candidate"]["sdpMLineIndex"],
          ));
          break;
      }
    });
  }

  Future<void> shareScreen() async {
    final stream = await navigator.mediaDevices.getDisplayMedia({"video": true, "audio": false});
    _localStream = stream;
    for (var track in stream.getTracks()) {
      _peerConnection!.addTrack(track, stream);
    }
    final offer = await _peerConnection!.createOffer({"offerToReceiveVideo": 1, "offerToReceiveAudio": 0});
    await _peerConnection!.setLocalDescription(offer);
    _channel.sink.add(jsonEncode({"type": "offer", "sdp": offer.sdp}));
  }

  void dispose() {
    _localStream?.dispose();
    _peerConnection?.close();
    _channel.sink.close();
  }
}