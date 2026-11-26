import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/style_catalog/models/reference_outfit.dart';

void main() {
  test('40 distinct curated reference outfits have usable metadata', () {
    expect(referenceOutfits, hasLength(40));
    expect(referenceOutfits.map((outfit) => outfit.id).toSet(), hasLength(40));
    expect(referenceOutfits.map((outfit) => outfit.style).toSet(), hasLength(6));

    for (final outfit in referenceOutfits) {
      expect(outfit.title.trim(), isNotEmpty);
      expect(outfit.top.trim(), isNotEmpty);
      expect(outfit.bottom.trim(), isNotEmpty);
      expect(outfit.shoes.trim(), isNotEmpty);
      expect(outfit.occasion.trim(), isNotEmpty);
      expect(outfit.season.trim(), isNotEmpty);
      expect(outfit.fit.trim(), isNotEmpty);
      expect(outfit.palette.trim(), isNotEmpty);
      expect(outfit.topColor >> 24, 0xFF);
      expect(outfit.bottomColor >> 24, 0xFF);
    }
  });

  test('favorite look ids survive preference serialization', () {
    final ids = referenceOutfits.take(5).map((e) => e.id).toSet();
    final stored = UserPreferences(
      styles: const {ClothingStyle.minimal},
      budget: ShoppingBudget.medium,
      favoriteOutfitIds: ids,
      isComplete: true,
    );
    final decoded = UserPreferences.fromJson(stored.toJson());
    expect(decoded.favoriteOutfitIds, ids);
    expect(decoded.styles, stored.styles);
    expect(decoded.budget, stored.budget);
    expect(decoded.isComplete, isTrue);
  });

  test('old saved preferences load without favorite ids', () {
    final decoded = UserPreferences.fromJson({
      'styles': ['classic'], 'budget': 'economic', 'isComplete': true,
    });
    expect(decoded.favoriteOutfitIds, isEmpty);
    expect(decoded.isComplete, isTrue);
  });
}
