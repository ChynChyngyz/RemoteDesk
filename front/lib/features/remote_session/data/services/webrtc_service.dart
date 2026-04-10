// features/auth/remote_session/data/services/webrtc_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  late WebSocketChannel _channel;
  final RTCVideoRenderer remoteRenderer;
  final VoidCallback? onStreamReceived;
  final List<RTCIceCandidate> _remoteCandidatesQueue = [];

  WebRTCService(this.remoteRenderer, {this.onStreamReceived});

  final Map<String, dynamic> _config = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
    ],
  };

  Future<void> connect({
    required String room,
    required String sessionToken,
    String? jwt,
    String? agentKey,
  }) async {
    final uri = Uri(
      scheme: 'ws',
      host: '127.0.0.1',
      // port: 8000,
      port: 80,
      path: '/ws/signal/$room/',
      queryParameters: {
        'token': sessionToken,
        if (jwt != null) 'jwt': jwt,
        if (agentKey != null) 'agent_key': agentKey,
      },
    );

    debugPrint("Connecting to WS: $uri");
    _channel = WebSocketChannel.connect(uri);

    _peerConnection = await createPeerConnection(_config);

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      debugPrint("ICE Connection State: $state");
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        debugPrint("Соединение прервано или заблокировано фаерволом.");
      }
    };

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
      if (event.streams.isNotEmpty) {
        debugPrint("Видеопоток получен!");
        remoteRenderer.srcObject = event.streams[0];

        if (onStreamReceived != null) {
          onStreamReceived!();
        }
      }
    };

    _channel.stream.listen((message) async {
      debugPrint("WS RECEIVE: ${message.substring(0, message.length > 50 ? 50 : message.length)}..."); // Сократим лог, чтобы не засорять консоль

      try {
        final data = jsonDecode(message);

        switch (data["type"]) {
          case "offer":
            final state = _peerConnection!.signalingState;
            if (state == RTCSignalingState.RTCSignalingStateStable || state == null) {
              debugPrint("Handling Offer...");
              await _peerConnection!.setRemoteDescription(RTCSessionDescription(data["sdp"], "offer"));
              final answer = await _peerConnection!.createAnswer();
              await _peerConnection!.setLocalDescription(answer);
              _channel.sink.add(jsonEncode({"type": "answer", "sdp": answer.sdp}));

              _processCandidatesQueue();
            } else {
              debugPrint("Игнорируем offer, так как state: $state");
            }
            break;

          case "answer":
            final state = _peerConnection!.signalingState;
            if (state == RTCSignalingState.RTCSignalingStateHaveLocalOffer || state == null) {
              debugPrint("Handling Answer...");
              await _peerConnection!.setRemoteDescription(RTCSessionDescription(data["sdp"], "answer"));

              _processCandidatesQueue();
            } else {
              debugPrint("Игнорируем дублирующийся answer, state: $state");
            }
            break;

          case "candidate":
            if (data["candidate"] != null) {
              final candidate = RTCIceCandidate(
                data["candidate"]["candidate"],
                data["candidate"]["sdpMid"],
                data["candidate"]["sdpMLineIndex"],
              );

              final remoteDesc = await _peerConnection!.getRemoteDescription();
              if (remoteDesc != null) {
                debugPrint("Adding Candidate immediately...");
                await _peerConnection!.addCandidate(candidate);
              } else {
                debugPrint("Remote description is null. Queuing candidate...");
                _remoteCandidatesQueue.add(candidate);
              }
            }
            break;
        }
      } catch (e) {
        debugPrint("Ошибка при обработке WebRTC сигнала: $e");
      }
    });
  }

  Future<void> _processCandidatesQueue() async {
    if (_remoteCandidatesQueue.isNotEmpty) {
      debugPrint("Processing ${_remoteCandidatesQueue.length} queued candidates...");
      for (var candidate in _remoteCandidatesQueue) {
        await _peerConnection!.addCandidate(candidate);
      }
      _remoteCandidatesQueue.clear();
    }
  }

  Future<void> shareScreen() async {
    try {
      debugPrint("Requesting Display Media...");

      MediaStream stream;

      if (kIsWeb) {
        stream = await navigator.mediaDevices.getDisplayMedia({
          "video": true,
          "audio": false
        });
      } else {
        final sources = await desktopCapturer.getSources(types: [SourceType.Screen, SourceType.Window]);

        if (sources.isEmpty) {
          debugPrint("No display sources found!");
          return;
        }

        DesktopCapturerSource? selectedSource;
        for (var s in sources) {
          if (s.type == SourceType.Screen) {
            selectedSource = s;
            break;
          }
        }
        selectedSource ??= sources.first;

        debugPrint("Selected source: ${selectedSource.id}");

        stream = await navigator.mediaDevices.getDisplayMedia({
          "video": {
            "mandatory": {
              "chromeMediaSource": "desktop",
              "chromeMediaSourceId": selectedSource.id,
            }
          },
          "audio": false
        });
      }

      debugPrint("Display Media Captured!");

      _localStream = stream;
      for (var track in stream.getTracks()) {
        _peerConnection!.addTrack(track, stream);
      }

      final offer = await _peerConnection!.createOffer({
        "offerToReceiveVideo": 1,
        "offerToReceiveAudio": 0
      });
      await _peerConnection!.setLocalDescription(offer);

      debugPrint("Sending Offer to Socket...");
      _channel.sink.add(jsonEncode({"type": "offer", "sdp": offer.sdp}));

    } catch (e) {
      debugPrint("Error sharing screen: $e");
    }
  }

  void dispose() {
    _localStream?.dispose();
    _peerConnection?.close();
    _channel.sink.close();
  }
}