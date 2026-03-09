// desktop/pages/user_home_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:front/features/auth/presentation/pages/remote_view_page.dart';

import 'package:flutter/foundation.dart' show kIsWeb;


class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final TextEditingController _remoteIdController = TextEditingController();
  String deviceId = "Fetching...";

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  Future<void> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceIdentifier = "Unknown";

    try {
      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        deviceIdentifier = webBrowserInfo.browserName.name;
      } else {
        if (Platform.isWindows) {
          WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
          deviceIdentifier = windowsInfo.computerName;
        } else if (Platform.isLinux) {
          LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
          deviceIdentifier = linuxInfo.name;
        }
      }

      if (!mounted) return;

      setState(() {
        deviceId = deviceIdentifier;
      });
    } catch (e) {
      debugPrint("Error fetching device info: $e");
      if (!mounted) return;
      setState(() {
        deviceId = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.computer,
                size: 60,
                color: Colors.red[700],
              ),
              const SizedBox(height: 20),
              const Text(
                "Your Device ID",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    deviceId,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: deviceId),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("ID copied"),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.green[600], size: 12),
                  const SizedBox(width: 8),
                  const Text(
                    "Ready for remote support",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                  ),
                  onPressed: _handleConnect,
                  child: const Text("Request Support"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleConnect() {
    final remoteId = deviceId.trim();
    if (remoteId.isEmpty || remoteId == "Fetching...") return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RemoteSessionPage(
          remoteId: remoteId,
          isTechnician: false,
        ),
      ),
    );
  }
}