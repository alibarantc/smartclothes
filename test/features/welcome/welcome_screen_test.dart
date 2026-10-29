import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/theme/app_theme.dart';
import 'package:smartclothes/features/welcome/presentation/welcome_screen.dart';

void main() {
  group('WelcomeScreen Tests', () {
    testWidgets('renders all welcome screen elements cleanly without overflow',
        (tester) async {
      // Test standard phone resolution (e.g. 400x800)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: WelcomeScreen(
            onGetStarted: () => buttonPressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppConstants.appName), findsWidgets);
      expect(find.text(AppConstants.appSlogan), findsOneWidget);
      expect(find.text(AppConstants.appDescription), findsOneWidget);
      expect(find.byIcon(Icons.checkroom_rounded), findsOneWidget);
      expect(find.text('Başla'), findsOneWidget);

      await tester.tap(find.text('Başla'));
      await tester.pump();

      expect(buttonPressed, isTrue);
    });

    testWidgets('renders properly on small screen without pixel overflow',
        (tester) async {
      // Test small phone resolution (e.g. 320x568 - iPhone SE 1st gen)
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: const WelcomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppConstants.appName), findsWidgets);
      expect(find.text('Başla'), findsOneWidget);
      // No RenderFlex overflow exception
      expect(tester.takeException(), isNull);
    });
  });
}
