import 'package:flutter_test/flutter_test.dart';

import 'package:kid_app/main.dart';

void main() {
  testWidgets('App launches and shows the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KidsLearningApp());

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
