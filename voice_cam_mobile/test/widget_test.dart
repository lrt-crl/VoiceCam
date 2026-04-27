import 'package:flutter_test/flutter_test.dart';
import 'package:voice_cam_mobile/main.dart';

void main() {
  testWidgets('Mobile app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: availableCameras() might need mocking in a real test environment.
    // For now, we just check if the app starts.
    await tester.pumpWidget(const VoiceCamApp(cameras: []));
    expect(find.text('VoiceCam Mobile'), findsOneWidget);
  });
}
