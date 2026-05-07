import 'package:flutter_test/flutter_test.dart';
import 'package:task_hub/main.dart';

void main() {
  testWidgets('TaskHub app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskHubApp());
    expect(find.text('Welcome to TaskHub.'), findsOneWidget);
  });
}
