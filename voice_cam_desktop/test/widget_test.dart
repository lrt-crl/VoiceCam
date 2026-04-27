import 'package:flutter_test/flutter_test.dart';
import 'package:voice_cam_desktop/main.dart';

void main() {
  testWidgets('Desktop app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VoiceCamDesktopApp());
    expect(find.text('VoiceCam Desktop'), findsOneWidget);
  });
}
