import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fuel_save/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and shows UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    app.main();
    await tester.pumpAndSettle();

    // Verify that the app shows the expected UI elements.
    expect(find.text('FuelSave'), findsOneWidget);
    expect(find.text('Find Cheapest Station'), findsOneWidget);
  });
}