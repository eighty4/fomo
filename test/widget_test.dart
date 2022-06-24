import 'package:flutter_test/flutter_test.dart';
import 'package:fomo/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  testWidgets('Renders a map', (WidgetTester tester) async {
    await tester.pumpWidget(const MapApp());
    expect(find.byType(GoogleMap), findsOneWidget);
  });
}
