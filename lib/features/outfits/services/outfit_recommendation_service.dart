import 'package:smartclothes/features/outfits/models/suggested_outfit.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/services/laundry_availability_service.dart';

/// Offline, explainable recommendations built only from actual clean garments.
///
/// There is no AI, web shopping data, weather provider or external image source.
/// Recompute on each request rather than caching potentially dirty garments.
class OutfitRecommendationService {
  const OutfitRecommendationService();

  static const _laundry = LaundryAvailabilityService();

  /// Maximum number of results for an on-device preview.
  static const int defaultLimit = 5;

  List<SuggestedOutfit> recommend({
    required String ownerId,
    required Iterable<ClothingItem> wardrobe,
    ClothingSeason? season,
    ClothingOccasion? occasion,
    int limit = defaultLimit,
  }) {
    if (limit <= 0) return <SuggestedOutfit>[];

    final allowed = _laundry.eligibleForOutfits(wardrobe)
        .where((item) => item.ownerId == ownerId)
        .where((item) => season == null ||
            item.seasons.isEmpty || item.seasons.contains(season))
        .where((item) => occasion == null ||
            item.occasions.isEmpty || item.occasions.contains(occasion))
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    // Corrupted legacy inventories may contain duplicate ids; keep only one.
    final unique = <String, ClothingItem>{
      for (final item in allowed) item.id: item,
    };
    final items = unique.values.toList();
    List<ClothingItem> category(ClothingCategory category) =>
        items.where((item) => item.category == category).toList();

    final tops = category(ClothingCategory.tops);
    final bottoms = category(ClothingCategory.bottoms);
    final dresses = category(ClothingCategory.dresses);
    final shoes = category(ClothingCategory.shoes);
    final outerwear = category(ClothingCategory.outerwear);

    final suggestions = <SuggestedOutfit>[];
    final usedIds = <String>{};

    void addOutfit(List<ClothingItem> garments) {
      if (garments.map((item) => item.id).toSet().length != garments.length) {
        return;
      }
      final ids = garments.map((item) => item.id).toList()..sort();
      final key = ids.join('|');
      if (!usedIds.add(key)) return;
      final score = _score(garments, season: season, occasion: occasion);
      final reasons = <String>['Dolabındaki temiz kıyafetlerden'];
      if (garments.any((item) => item.isFavorite)) {
        reasons.add('Favori parçan kullanıldı');
      }
      if (_neutralOrMatching(garments)) {
        reasons.add('Uyumlu veya nötr renkler');
      }
      suggestions.add(SuggestedOutfit(
        id: key,
        items: List<ClothingItem>.unmodifiable(garments),
        score: score,
        reasons: List<String>.unmodifiable(reasons),
      ));
    }

    // For a cold season optionally include an owned, clean coat/jacket.
    ClothingItem? layerFor(List<ClothingItem> base) {
      if (season != ClothingSeason.winter &&
          season != ClothingSeason.autumn) return null;
      if (outerwear.isEmpty) return null;
      final ranked = [...outerwear]..sort((a, b) {
          final aScore = _score([...base, a], season: season, occasion: occasion);
          final bScore = _score([...base, b], season: season, occasion: occasion);
          final compare = bScore.compareTo(aScore);
          return compare == 0 ? a.id.compareTo(b.id) : compare;
        });
      return ranked.first;
    }

    for (final top in tops) {
      for (final bottom in bottoms) {
        for (final shoe in shoes) {
          final parts = <ClothingItem>[top, bottom, shoe];
          final layer = layerFor(parts);
          if (layer != null) parts.add(layer);
          addOutfit(parts);
        }
      }
    }

    // Dresses are an alternative to tops+bottoms, never worn as both.
    for (final dress in dresses) {
      for (final shoe in shoes) {
        final parts = <ClothingItem>[dress, shoe];
        final layer = layerFor(parts);
        if (layer != null) parts.add(layer);
        addOutfit(parts);
      }
    }

    suggestions.sort((a, b) {
      final result = b.score.compareTo(a.score);
      return result != 0 ? result : a.id.compareTo(b.id);
    });
    return List<SuggestedOutfit>.unmodifiable(suggestions.take(limit));
  }

  int _score(
    List<ClothingItem> items, {
    ClothingSeason? season,
    ClothingOccasion? occasion,
  }) {
    var score = 10;
    for (final item in items) {
      if (item.isFavorite) score += 5;
      if (season != null && item.seasons.contains(season)) score += 3;
      if (occasion != null && item.occasions.contains(occasion)) score += 3;
    }
    if (_neutralOrMatching(items)) score += 4;
    return score;
  }

  static const _neutralColors = <String>{
    'siyah', 'beyaz', 'gri', 'bej', 'krem', 'ekru',
    'lacivert', 'kahverengi', 'antrasit', 'füme', 'taş',
  };

  bool _neutralOrMatching(List<ClothingItem> items) {
    final colors = items
        .map((item) => item.color.trim().toLowerCase())
        .where((color) => color.isNotEmpty)
        .toList();
    if (colors.isEmpty) return false;
    final accentColors =
        colors.where((color) => !_neutralColors.contains(color)).toSet();
    return accentColors.length <= 1;
  }
}
