import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/style_catalog/models/reference_outfit.dart';
import 'package:smartclothes/features/style_profile/models/style_profile.dart';

/// Deterministic, offline style analysis of the user's liked reference looks.
///
/// One reference look contributes at most one vote for a given tag. Unknown ids
/// are ignored, and all ties use stable ordering for reproducible results.
class StyleProfileService {
  const StyleProfileService({this.catalog = referenceOutfits});

  final List<ReferenceOutfit> catalog;

  StyleProfile analyze(Iterable<String> favoriteOutfitIds) {
    final indexed = <String, ReferenceOutfit>{
      for (final outfit in catalog) outfit.id: outfit,
    };
    final selectedOutfits = favoriteOutfitIds
        .toSet()
        .map((id) => indexed[id])
        .whereType<ReferenceOutfit>()
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    final total = selectedOutfits.length;
    final styleCounts = <ClothingStyle, int>{};
    final colorCounts = <String, int>{};
    final fitCounts = <String, int>{};
    final occasionCounts = <String, int>{};

    for (final outfit in selectedOutfits) {
      styleCounts.update(outfit.style, (value) => value + 1,
          ifAbsent: () => 1);

      // A palette can contain multiple colors, separated by slashes.
      // Repeated color labels within a single look count only once.
      final colors = outfit.palette
          .split('/')
          .map((color) => color.trim().toLowerCase())
          .where((color) => color.isNotEmpty)
          .toSet();
      for (final color in colors) {
        colorCounts.update(color, (value) => value + 1,
            ifAbsent: () => 1);
      }

      final fit = outfit.fit.trim().toLowerCase();
      if (fit.isNotEmpty) {
        fitCounts.update(fit, (value) => value + 1, ifAbsent: () => 1);
      }

      final occasion = outfit.occasion.trim().toLowerCase();
      if (occasion.isNotEmpty) {
        occasionCounts.update(occasion, (value) => value + 1,
            ifAbsent: () => 1);
      }
    }

    // Explicit enum order is the tie breaker for styles.
    final styles = [
      for (final style in ClothingStyle.values)
        if (styleCounts.containsKey(style))
          StyleAffinity(
            style: style,
            count: styleCounts[style]!,
            share: styleCounts[style]! / total,
          ),
    ]..sort((a, b) {
        final byCount = b.count.compareTo(a.count);
        return byCount != 0 ? byCount : a.style.index.compareTo(b.style.index);
      });

    return StyleProfile(
      analyzedOutfitCount: total,
      styles: List<StyleAffinity>.unmodifiable(styles),
      colors: _rankTraits(colorCounts, total),
      fits: _rankTraits(fitCounts, total),
      occasions: _rankTraits(occasionCounts, total),
    );
  }

  static List<StyleTrait> _rankTraits(Map<String, int> counts, int total) {
    final sorted = [
      for (final entry in counts.entries)
        StyleTrait(
          label: entry.key,
          count: entry.value,
          share: entry.value / total,
        ),
    ]..sort((a, b) {
        final byCount = b.count.compareTo(a.count);
        return byCount != 0 ? byCount : a.label.compareTo(b.label);
      });
    return List<StyleTrait>.unmodifiable(sorted);
  }
}
