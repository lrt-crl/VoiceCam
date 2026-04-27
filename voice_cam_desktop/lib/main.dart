import 'package:flutter/material.dart';

void main() {
  runApp(const VoiceCamDesktopApp());
}

class VoiceCamDesktopApp extends StatelessWidget {
  const VoiceCamDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoiceCam Desktop',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const DesktopHomeScreen(),
    );
  }
}

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  bool _isServerActive = false;
  final List<String> _logs = [];

  void _addLog(String msg) {
    setState(() {
      _logs.insert(0, "${DateTime.now().toLocal()}: $msg");
    });
  }

  void _toggleServer() {
    setState(() {
      _isServerActive = !_isServerActive;
      _addLog(_isServerActive ? "Server started on port 8080" : "Server stopped");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VoiceCam Desktop')),
      body: Row(
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.hub), label: Text('Connect')),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
            ],
            selectedIndex: 0,
            onDestinationSelected: (i) {},
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: _toggleServer,
                    icon: Icon(_isServerActive ? Icons.stop : Icons.play_arrow),
                    label: Text(_isServerActive ? 'Stop Server' : 'Start Server'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isServerActive ? Colors.red.shade100 : Colors.green.shade100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Activity Logs", style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) => Text(_logs[index], style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
