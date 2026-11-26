import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/auth/presentation/auth_gate.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/onboarding/presentation/onboarding_screen.dart';
import 'package:smartclothes/features/onboarding/services/preferences_store.dart';
import 'package:smartclothes/features/style_catalog/models/reference_outfit.dart';
import 'package:smartclothes/features/style_catalog/presentation/reference_outfit_gallery_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AuthService.instance = AuthService();
  });

  testWidgets('requires five favorites and saves stable ids', (tester) async {
    Set<String>? saved;
    await tester.pumpWidget(MaterialApp(
      home: ReferenceOutfitGalleryScreen(onSave: (ids) async { saved = ids; }),
    ));
    final button = find.byKey(const ValueKey('save-outfit-favorites'));
    expect(find.text('0 / 5 seçildi'), findsOneWidget);
    expect(tester.widget<FilledButton>(button).onPressed, isNull);

    await tester.pumpWidget(MaterialApp(
      home: ReferenceOutfitGalleryScreen(
        key: const ValueKey('selected-gallery'),
        initialSelection: referenceOutfits.take(5).map((e) => e.id).toSet(),
        onSave: (ids) async { saved = ids; },
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('5 / 5 seçildi'), findsOneWidget);
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(saved, referenceOutfits.take(5).map((e) => e.id).toSet());
  });

  testWidgets('new demo user sees gallery after style and budget', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AuthGate()));
    AuthService.instance.enterDemoMode();
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    await tester.tap(find.text('Minimal'));
    await tester.tap(find.text('İleri'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Orta'));
    await tester.tap(find.text('Tercihleri Kaydet'));
    await tester.pumpAndSettle();
    expect(find.byType(ReferenceOutfitGalleryScreen), findsOneWidget);
    final saved = await const PreferencesStore().load('demo');
    expect(saved?.isComplete, isFalse);
    expect(saved?.styles.isNotEmpty, isTrue);
  });
}
