import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/core/navigation/main_navigation_screen.dart';
import 'package:smartclothes/core/theme/app_theme.dart';
import 'package:smartclothes/features/auth/presentation/auth_gate.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/onboarding/presentation/onboarding_screen.dart';
import 'package:smartclothes/features/onboarding/services/preferences_store.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AuthService.instance = AuthService();
  });

  testWidgets('requires style and budget and saves selected preferences',
      (tester) async {
    UserPreferences? submitted;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: OnboardingScreen(onSubmit: (preferences) async {
          submitted = preferences;
        }),
      ),
    );

    expect(find.text('Tarzın nasıl?'), findsOneWidget);
    await tester.tap(find.text('İleri'));
    await tester.pump();
    expect(find.text('Devam etmek için en az bir tarz seç.'), findsOneWidget);

    await tester.tap(find.text('Minimal'));
    await tester.tap(find.text('İleri'));
    await tester.pumpAndSettle();

    expect(find.text('Bütçen nasıl?'), findsOneWidget);
    await tester.tap(find.text('Tercihleri Kaydet'));
    await tester.pump();
    expect(find.text('Lütfen bir bütçe aralığı seç.'), findsOneWidget);

    await tester.tap(find.text('Orta'));
    await tester.tap(find.text('Tercihleri Kaydet'));
    await tester.pumpAndSettle();

    expect(submitted?.styles, {ClothingStyle.minimal});
    expect(submitted?.budget, ShoppingBudget.medium);
    expect(submitted?.isComplete, isTrue);
  });

  testWidgets('demo onboarding appears once and stays completed', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
    AuthService.instance.enterDemoMode();
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(MainNavigationScreen), findsNothing);

    await tester.tap(find.text('Şimdilik atla'));
    await tester.pumpAndSettle();
    expect(find.byType(MainNavigationScreen), findsOneWidget);

    const store = PreferencesStore();
    expect((await store.load('demo'))?.isComplete, isTrue);

    await AuthService.instance.signOut();
    await tester.pumpAndSettle();
    AuthService.instance.enterDemoMode();
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(MainNavigationScreen), findsOneWidget);
  });
}
