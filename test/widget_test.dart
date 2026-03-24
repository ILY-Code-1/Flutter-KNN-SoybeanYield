import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_knn_soybean/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SoyBeanYieldApp());
    expect(find.byType(SoyBeanYieldApp), findsOneWidget);
  });
}
