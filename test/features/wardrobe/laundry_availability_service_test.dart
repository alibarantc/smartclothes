import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/services/laundry_availability_service.dart';

void main() {
  const service = LaundryAvailabilityService();
  final now = DateTime.utc(2026, 11, 26);
  ClothingItem garment(String id, LaundryStatus status) => ClothingItem(
        id: id,
        ownerId: 'demo',
        name: id,
        category: ClothingCategory.tops,
        color: 'siyah',
        createdAt: now,
        updatedAt: now,
        laundryStatus: status,
      );

  test('clean items remain eligible, dirty items are excluded', () {
    final clean = garment('shirt-clean', LaundryStatus.clean);
    final dirty = garment('shirt-dirty', LaundryStatus.dirty);
    final candidates = service.eligibleForOutfits([dirty, clean]);
    expect(candidates, [clean]);
    expect(candidates.single.laundryStatus, LaundryStatus.clean);
  });

  test('dirty items remain owned, never classified as missing', () {
    final clean = garment('shirt-clean', LaundryStatus.clean);
    final dirty = garment('shirt-dirty', LaundryStatus.dirty);
    final wardrobe = [clean, dirty];
    expect(service.ownedItemIds(wardrobe), {'shirt-clean', 'shirt-dirty'});
    expect(
      service.missingItemIds(
        desiredItemIds: ['shirt-dirty', 'not-owned'],
        wardrobe: wardrobe,
      ),
      {'not-owned'},
    );
  });

  test('changing laundry status immediately changes eligible candidates', () {
    final dirty = garment('jacket', LaundryStatus.dirty);
    expect(service.eligibleForOutfits([dirty]), isEmpty);
    final clean = dirty.copyWith(laundryStatus: LaundryStatus.clean);
    expect(service.eligibleForOutfits([clean]), [clean]);
    expect(service.missingItemIds(
      desiredItemIds: ['jacket'], wardrobe: [dirty],
    ), isEmpty);
  });

  test('empty wardrobe returns no candidates or owned ids', () {
    expect(service.eligibleForOutfits(<ClothingItem>[]), isEmpty);
    expect(service.ownedItemIds(<ClothingItem>[]), isEmpty);
    expect(service.missingItemIds(
      desiredItemIds: ['sweater'], wardrobe: <ClothingItem>[],
    ), {'sweater'});
  });
}
