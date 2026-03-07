import 'package:flutter_test/flutter_test.dart';

import 'package:jellyfin_client/app.dart';

void main() {
  testWidgets('App renders startup screen', (WidgetTester tester) async {
    await tester.pumpWidget(const JellyfinApp());
    expect(find.text('Jellyfin'), findsOneWidget);
  });
}
