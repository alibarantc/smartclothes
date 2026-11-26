import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';

/// One ephemeral suggestion made entirely of garments owned by the user.
/// No new wardrobe items or downloaded product photos are generated.
class SuggestedOutfit {
  const SuggestedOutfit({
    required this.id,
    required this.items,
    required this.score,
    required this.reasons,
  });

  /// Stable combination key of the original wardrobe garment ids.
  final String id;
  final List<ClothingItem> items;
  final int score;
  final List<String> reasons;
}
