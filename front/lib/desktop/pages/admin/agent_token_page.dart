// desktop/pages/admin/agent_token_page.dart

/// POST /generate-agent-token

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/core/network/dio_admin.dart';

class AgentTokenPage extends StatefulWidget {
  const AgentTokenPage({super.key});

  @override
  State<AgentTokenPage> createState() => _AgentTokenPageState();
}

class _AgentTokenPageState extends State<AgentTokenPage> {

  String token = "";
  bool loading = false;

  Future<void> generateToken() async {

    setState(() => loading = true);

    final response = await DioAdmin.generateAgentToken();

    setState(() {
      token = response.data["org_token"];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Generate Agent Token",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: loading ? null : generateToken,
            child: const Text("Generate Token"),
          ),

          const SizedBox(height: 20),

          if(token.isNotEmpty)
            Row(
              children: [

                Expanded(child: SelectableText(token)),

                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: token));
                  },
                )

              ],
            )

        ],
      ),
    );
  }
}