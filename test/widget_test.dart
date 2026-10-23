// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cecs453lab4/main.dart';
import 'package:cecs453lab4/mortgage.dart';

void main() {
  testWidgets('MortgageApp builds smoke test', (WidgetTester tester) async {
    final mortgage = Mortgage();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: mortgage,
        child: const MortgageApp(),
      ),
    );

    expect(find.text('MortgageV0'), findsOneWidget);
  });
}
