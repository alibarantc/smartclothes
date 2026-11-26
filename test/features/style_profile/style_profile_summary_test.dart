import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/onboarding/presentation/profile_preferences_panel.dart';
import 'package:smartclothes/features/onboarding/services/preferences_store.dart';
import 'package:smartclothes/features/style_catalog/presentation/reference_outfit_gallery_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AuthService.instance = AuthService();
  });

  Future<void> showPanel(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: ProfilePreferencesPanel()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('explains why a profile is unavailable before five choices',
      (tester) async {
    await showPanel(tester);
    expect(find.text('Stil Analizim'), findsOneWidget);
    expect(find.text('Stil analizini görmek için en az 5 kombin beğen.'),
        findsOneWidget);
    expect(find.text('0 / 5 kombin seçildi'), findsOneWidget);
    expect(find.text('Kombinleri İncele'), findsOneWidget);
  });

  testWidgets('shows actual styles and selected look count', (tester) async {
    const store = PreferencesStore();
    await store.save(
      'demo',
      const UserPreferences(
        favoriteOutfitIds: {
          'minimal-01', 'minimal-02', 'minimal-03', 'classic-01', 'classic-02'
        },
        isComplete: true,
      ),
    );
    await showPanel(tester);
    expect(find.text('5 kombin incelendi'), findsOneWidget);
    expect(find.text('Baskın tarzın: Minimal'), findsOneWidget);
    expect(find.text('Minimal %60'), findsOneWidget);
    expect(find.text('Klasik %40'), findsOneWidget);
  });

  testWidgets('editing favorites refreshes the computed profile',
      (tester) async {
    const store = PreferencesStore();
    await store.save(
      'demo',
      const UserPreferences(
        favoriteOutfitIds: {
          'minimal-02', 'minimal-03', 'minimal-04',
          'minimal-05', 'minimal-06'
        },
        isComplete: true,
      ),
    );
    await showPanel(tester);
    expect(find.text('5 kombin incelendi'), findsOneWidget);
    await tester.ensureVisible(find.text('5 kombin seçildi'));
    await tester.tap(find.text('5 kombin seçildi'));
    await tester.pumpAndSettle();
    expect(find.byType(ReferenceOutfitGalleryScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('reference-minimal-01')));
    await tester.pump();
    expect(find.text('6 / 5 seçildi'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('save-outfit-favorites')));
    await tester.pumpAndSettle();

    expect(find.text('6 kombin incelendi'), findsOneWidget);
    expect((await store.load('demo'))?.favoriteOutfitIds.length, 6);
    expect(find.byType(ReferenceOutfitGalleryScreen), findsNothing);
  });

  testWidgets('old completed demo preferences remain editable without reset',
      (tester) async {
    const store = PreferencesStore();
    await store.save('demo', const UserPreferences(isComplete: true));
    await showPanel(tester);
    expect(find.text('0 / 5 kombin seçildi'), findsOneWidget);
    expect((await store.load('demo'))?.isComplete, isTrue);
  });
}
