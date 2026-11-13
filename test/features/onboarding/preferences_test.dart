import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/onboarding/services/preferences_store.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('preferences serialize all selected styles and budget', () {
    const original = UserPreferences(
      styles: {ClothingStyle.minimal, ClothingStyle.streetwear},
      budget: ShoppingBudget.medium,
      isComplete: true,
    );

    final restored = UserPreferences.fromJson(original.toJson());
    expect(restored.styles, original.styles);
    expect(restored.budget, ShoppingBudget.medium);
    expect(restored.isComplete, isTrue);
  });

  test('unknown values are ignored without losing completion status', () {
    final restored = UserPreferences.fromJson({
      'styles': ['minimal', 'not-a-style'],
      'budget': 'unknown',
      'isComplete': true,
    });

    expect(restored.styles, {ClothingStyle.minimal});
    expect(restored.budget, isNull);
    expect(restored.isComplete, isTrue);
  });

  test('different accounts and demo mode do not share saved preferences',
      () async {
    const store = PreferencesStore();
    const demoPreferences = UserPreferences(
      styles: {ClothingStyle.casual},
      budget: ShoppingBudget.economic,
      isComplete: true,
    );
    expect(await store.save('demo', demoPreferences), isTrue);

    expect((await store.load('demo'))?.styles, {ClothingStyle.casual});
    expect(await store.load('firebase-user-123'), isNull);
  });

  test('skipped onboarding remains complete after reload', () async {
    const store = PreferencesStore();
    expect(await store.save('demo', const UserPreferences(isComplete: true)),
        isTrue);

    final reloaded = await store.load('demo');
    expect(reloaded?.isComplete, isTrue);
    expect(reloaded?.styles, isEmpty);
    expect(reloaded?.budget, isNull);
  });

  test('malformed storage data does not crash onboarding', () async {
    const store = PreferencesStore();
    final local = await SharedPreferences.getInstance();
    await local.setString(store.storageKey('demo'), 'not-json');
    expect(await store.load('demo'), isNull);
  });
}
