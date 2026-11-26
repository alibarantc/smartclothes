import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/style_catalog/models/reference_outfit.dart';
import 'package:smartclothes/features/style_profile/services/style_profile_service.dart';

void main() {
  const service = StyleProfileService();

  test('builds a style profile from five selected looks', () {
    final profile = service.analyze(
      referenceOutfits.take(5).map((outfit) => outfit.id),
    );

    expect(profile.analyzedOutfitCount, 5);
    expect(profile.hasEnoughData, isTrue);
    expect(profile.dominantStyle, ClothingStyle.minimal);
    expect(profile.styles, hasLength(1));
    expect(profile.styles.single.count, 5);
    expect(profile.styles.single.share, 1);
    expect(profile.colors, isNotEmpty);
    expect(profile.fits, isNotEmpty);
    expect(profile.occasions, isNotEmpty);
  });

  test('weights styles as a share of recognized distinct looks', () {
    final profile = service.analyze([
      'minimal-01', 'minimal-02', 'minimal-03',
      'classic-01', 'classic-02',
    ]);

    expect(profile.styles.map((entry) => entry.style).toList(),
        [ClothingStyle.minimal, ClothingStyle.classic]);
    expect(profile.styles[0].count, 3);
    expect(profile.styles[0].share, closeTo(0.6, 0.00001));
    expect(profile.styles[1].count, 2);
    expect(profile.styles[1].share, closeTo(0.4, 0.00001));
  });

  test('deduplicates ids, excludes unknown ids and preserves input independence', () {
    final profile = service.analyze([
      'minimal-01', 'minimal-01', 'missing-001', 'classic-01',
    ]);

    expect(profile.analyzedOutfitCount, 2);
    expect(profile.styles.map((entry) => entry.style).toList(),
        [ClothingStyle.minimal, ClothingStyle.classic]);
    expect(profile.hasEnoughData, isFalse);
    expect(
      service.analyze(['classic-01', 'minimal-01']).styles
          .map((entry) => entry.style).toList(),
      [ClothingStyle.minimal, ClothingStyle.classic],
    );
  });

  test('counts each palette color once per look and sorts ties alphabetically', () {
    final selected = service.analyze(['minimal-01', 'minimal-02']);
    expect(selected.colors.map((entry) => entry.label), contains('beyaz'));
    expect(selected.colors.first.count, greaterThanOrEqualTo(1));
    expect(
      selected.colors.map((entry) => entry.count).every((count) => count <= 2),
      isTrue,
    );
    // With one item per style, an enum order tie is deterministic.
    final tie = service.analyze(['classic-01', 'minimal-01']);
    expect(tie.dominantStyle, ClothingStyle.minimal);
  });



  test('each palette color counts once per reference look', () {
    const customCatalog = <ReferenceOutfit>[
      ReferenceOutfit(
        id: 'custom-1',
        title: 'Özel kombin',
        style: ClothingStyle.casual,
        top: 'Tişört',
        bottom: 'Pantolon',
        shoes: 'Ayakkabı',
        outerwear: '',
        occasion: 'Günlük',
        season: 'Yaz',
        fit: 'Rahat',
        palette: 'Beyaz / beyaz / Siyah',
        topColor: 0xFFFFFFFF,
        bottomColor: 0xFF111111,
        layerColor: 0xFFCCCCCC,
      ),
    ];
    const customService = StyleProfileService(catalog: customCatalog);
    final profile = customService.analyze(['custom-1', 'custom-1']);

    expect(profile.analyzedOutfitCount, 1);
    expect(profile.colors.map((entry) => entry.label).toList(),
        ['beyaz', 'siyah']);
    expect(profile.colors.every((entry) => entry.count == 1), isTrue);
    expect(profile.fits.single.label, 'rahat');
    expect(profile.occasions.single.label, 'günlük');
  });

  test('empty and invalid selections return a safe, empty profile', () {
    for (final input in [<String>[], <String>['not-in-catalog']]) {
      final profile = service.analyze(input);
      expect(profile.analyzedOutfitCount, 0);
      expect(profile.hasEnoughData, isFalse);
      expect(profile.dominantStyle, isNull);
      expect(profile.styles, isEmpty);
      expect(profile.colors, isEmpty);
      expect(profile.fits, isEmpty);
      expect(profile.occasions, isEmpty);
    }
  });

  test('profiles are re-derived from changed favorites without persistence', () {
    final original = service.analyze(
      ['minimal-01', 'minimal-02', 'minimal-03', 'minimal-04', 'minimal-05'],
    );
    final changed = service.analyze(
      ['classic-01', 'classic-02', 'classic-03', 'classic-04', 'classic-05'],
    );
    expect(original.dominantStyle, ClothingStyle.minimal);
    expect(changed.dominantStyle, ClothingStyle.classic);
    expect(changed.analyzedOutfitCount, original.analyzedOutfitCount);
  });

  test('profile threshold uses recognized looks, not merely submitted ids', () {
    final profile = service.analyze([
      'minimal-01', 'minimal-02', 'classic-01',
      'unknown-a', 'unknown-b', 'unknown-c',
    ]);
    expect(profile.analyzedOutfitCount, 3);
    expect(profile.hasEnoughData, isFalse);
  });

  test('catalog order and input order do not alter ranked traits', () {
    final reversedService = StyleProfileService(
      catalog: referenceOutfits.reversed.toList(),
    );
    final first = service.analyze(
      ['minimal-01', 'street-01', 'classic-01', 'sporty-01', 'casual-01'],
    );
    final second = reversedService.analyze(
      ['casual-01', 'sporty-01', 'classic-01', 'street-01', 'minimal-01'],
    );
    expect(first.styles.map((entry) => entry.style).toList(),
        second.styles.map((entry) => entry.style).toList());
    expect(first.colors.map((entry) => entry.label).toList(),
        second.colors.map((entry) => entry.label).toList());
  });
}
