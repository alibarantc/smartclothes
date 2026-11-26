import 'package:smartclothes/features/onboarding/models/user_preferences.dart';

/// A clothing style's share among the recognized favorite reference looks.
class StyleAffinity {
  const StyleAffinity({
    required this.style,
    required this.count,
    required this.share,
  });

  final ClothingStyle style;
  final int count;
  final double share;
}

/// Ranked tag derived from the reference looks (color, fit, or occasion).
class StyleTrait {
  const StyleTrait({
    required this.label,
    required this.count,
    required this.share,
  });

  final String label;
  final int count;
  final double share;
}

/// Derived on demand; never persisted independently of favoriteOutfitIds.
class StyleProfile {
  const StyleProfile({
    required this.analyzedOutfitCount,
    required this.styles,
    required this.colors,
    required this.fits,
    required this.occasions,
  });

  static const int minimumOutfits = 5;

  final int analyzedOutfitCount;
  final List<StyleAffinity> styles;
  final List<StyleTrait> colors;
  final List<StyleTrait> fits;
  final List<StyleTrait> occasions;

  bool get hasEnoughData => analyzedOutfitCount >= minimumOutfits;

  ClothingStyle? get dominantStyle =>
      styles.isEmpty ? null : styles.first.style;
}
