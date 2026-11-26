import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';

/// Uses laundry availability without removing owned garments from inventory.
/// A later outfit generator can call [eligibleForOutfits] as its input.
class LaundryAvailabilityService {
  const LaundryAvailabilityService();

  /// Only clean pieces may participate in suggested combinations.
  List<ClothingItem> eligibleForOutfits(Iterable<ClothingItem> wardrobe) =>
      List<ClothingItem>.unmodifiable(
        wardrobe.where((item) => item.laundryStatus == LaundryStatus.clean),
      );

  /// Dirty items remain owned, so a wish-list or missing-item algorithm must
  /// use the complete inventory rather than only outfit-eligible garments.
  Set<String> ownedItemIds(Iterable<ClothingItem> wardrobe) =>
      Set<String>.unmodifiable(wardrobe.map((item) => item.id));

  Set<String> missingItemIds({
    required Iterable<String> desiredItemIds,
    required Iterable<ClothingItem> wardrobe,
  }) {
    final owned = ownedItemIds(wardrobe);
    return Set<String>.unmodifiable(
      desiredItemIds.toSet().difference(owned),
    );
  }
}
