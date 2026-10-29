import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/app/smart_clothes_app.dart';
import 'package:smartclothes/core/constants/app_constants.dart';

void main() {
  testWidgets('SmartClothesApp renders correctly and displays welcome screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmartClothesApp());
    await tester.pumpAndSettle();

    // Verify App Name is visible
    expect(find.text(AppConstants.appName), findsWidgets);

    // Verify Slogan is displayed
    expect(find.text(AppConstants.appSlogan), findsOneWidget);

    // Verify Description is displayed
    expect(find.text(AppConstants.appDescription), findsOneWidget);

    // Verify Wardrobe Icon is displayed
    expect(find.byIcon(Icons.checkroom_rounded), findsOneWidget);

    // Verify Get Started Button
    expect(find.text('Başla'), findsOneWidget);

    // Verify old debug commit badge is removed
    expect(find.text('Commit #01: Temel Proje İskeleti'), findsNothing);
  });
}
