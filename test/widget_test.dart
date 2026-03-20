import 'package:flutter_test/flutter_test.dart';
import 'package:signly_sign_language/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SignlyApp());
    expect(find.text('Signly'), findsWidgets);
  });
}
