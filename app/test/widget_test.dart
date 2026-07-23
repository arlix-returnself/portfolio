import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/app.dart';

void main() {
  testWidgets('PortfolioApp shows an error screen when profile fails to load', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp(profile: null));

    expect(find.text('Could not load profile data.'), findsOneWidget);
  });
}
