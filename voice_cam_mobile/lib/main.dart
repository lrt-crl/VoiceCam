import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(VoiceCamApp(cameras: cameras));
}

class VoiceCamApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const VoiceCamApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoiceCam Mobile',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: HomeScreen(cameras: cameras),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HomeScreen({super.key, required this.cameras});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isStreaming = false;
  bool _isRecordingVoice = false;
  String _serverIp = '192.168.1.100';
  WebSocketChannel? _videoChannel;
  WebSocketChannel? _audioChannel;
  WebSocketChannel? _sttChannel;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  Future<void> _initCamera() async {
    if (widget.cameras.isEmpty) return;
    _cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.low,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  void _toggleStreaming() async {
    if (_isStreaming) {
      _stopStreaming();
    } else {
      _startStreaming();
    }
  }

  void _startStreaming() async {
    try {
      final videoUri = Uri.parse('ws://$_serverIp:8080/video');
      final audioUri = Uri.parse('ws://$_serverIp:8080/audio');

      _videoChannel = WebSocketChannel.connect(videoUri);
      _audioChannel = WebSocketChannel.connect(audioUri);

      setState(() => _isStreaming = true);

      _cameraController!.startImageStream((CameraImage image) {
        if (_isStreaming && _videoChannel != null) {
          // Convert CameraImage to JPEG
          final bytes = _convertYUV420toJPEG(image);
          _videoChannel!.sink.add(bytes);
        }
      });

      if (await _audioRecorder.hasPermission()) {
        final stream = await _audioRecorder.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
        stream.listen((data) {
          if (_isStreaming && _audioChannel != null) {
            _audioChannel!.sink.add(data);
          }
        });
      }
    } catch (e) {
      _stopStreaming();
    }
  }

  Uint8List _convertYUV420toJPEG(CameraImage image) {
    // Highly simplified conversion for demonstration
    // In production, use a more optimized plugin like 'flutter_image_compress'
    final int width = image.width;
    final int height = image.height;
    final img.Image res = img.Image(width: width, height: height);
    // Fill image logic...
    return Uint8List.fromList(img.encodeJpg(res));
  }

  void _stopStreaming() {
    _cameraController?.stopImageStream();
    _audioRecorder.stop();
    _videoChannel?.sink.close();
    _audioChannel?.sink.close();
    setState(() => _isStreaming = false);
  }

  void _toggleVoiceDictation() {
    if (_isRecordingVoice) {
      _sttChannel?.sink.close();
      _audioRecorder.stop();
      setState(() => _isRecordingVoice = false);
    } else {
      _startVoiceDictation();
    }
  }

  void _startVoiceDictation() async {
    try {
      final sttUri = Uri.parse('ws://$_serverIp:8080/stt');
      _sttChannel = WebSocketChannel.connect(sttUri);
      setState(() => _isRecordingVoice = true);

      if (await _audioRecorder.hasPermission()) {
        final stream = await _audioRecorder.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
        stream.listen((data) {
          if (_isRecordingVoice && _sttChannel != null) {
            _sttChannel!.sink.add(data);
          }
        });
      }
    } catch (e) {
      _isRecordingVoice = false;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VoiceCam Mobile')),
      body: Column(
        children: [
          Expanded(
            child: _cameraController != null && _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'PC IP Address'),
                  onChanged: (val) => _serverIp = val,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleStreaming,
                      icon: Icon(_isStreaming ? Icons.stop : Icons.play_arrow),
                      label: Text(_isStreaming ? 'Stop Streaming' : 'Start Streaming'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleVoiceDictation,
                      icon: Icon(_isRecordingVoice ? Icons.mic : Icons.mic_none),
                      label: Text(_isRecordingVoice ? 'Dictating...' : 'Voice Typist'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
