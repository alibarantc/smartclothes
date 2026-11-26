import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';

void main() {
  final created = DateTime.utc(2026, 11, 20, 12);
  final updated = DateTime.utc(2026, 11, 21, 12);

  ClothingItem example() => ClothingItem(
        id: 'garment-01',
        ownerId: 'demo',
        name: 'Mavi gömlek',
        category: ClothingCategory.tops,
        color: 'mavi',
        seasons: const {ClothingSeason.spring, ClothingSeason.autumn},
        occasions: const {ClothingOccasion.work, ClothingOccasion.everyday},
        brand: 'Mavi',
        notes: 'Pamuk',
        photoPath: 'users/demo/wardrobe/garment-01/photo',
        isFavorite: true,
        createdAt: created,
        updatedAt: updated,
      );

  test('garment metadata survives JSON round trip', () {
    final item = example();
    final restored = ClothingItem.fromJson(item.toJson());
    expect(restored.id, item.id);
    expect(restored.ownerId, item.ownerId);
    expect(restored.name, item.name);
    expect(restored.category, ClothingCategory.tops);
    expect(restored.color, 'mavi');
    expect(restored.seasons, item.seasons);
    expect(restored.occasions, item.occasions);
    expect(restored.brand, 'Mavi');
    expect(restored.notes, 'Pamuk');
    expect(restored.photoPath, item.photoPath);
    expect(restored.isFavorite, isTrue);
    expect(restored.laundryStatus, LaundryStatus.clean);
    expect(restored.toJson()['laundryStatus'], 'clean');
    expect(restored.createdAt, created);
    expect(restored.updatedAt, updated);
  });

  test('old saved garments default to clean, unknown values fail closed', () {
    final legacy = example().toJson()..remove('laundryStatus');
    expect(ClothingItem.fromJson(legacy).laundryStatus, LaundryStatus.clean);

    final invalid = example().toJson()..['laundryStatus'] = 'unknown';
    expect(ClothingItem.fromJson(invalid).laundryStatus, LaundryStatus.dirty);
  });

  test('dirty items round-trip and copyWith preserves ownership', () {
    final changed = example().copyWith(laundryStatus: LaundryStatus.dirty);
    expect(changed.laundryStatus, LaundryStatus.dirty);
    expect(changed.ownerId, example().ownerId);
    expect(changed.id, example().id);
    expect(ClothingItem.fromJson(changed.toJson()).laundryStatus,
        LaundryStatus.dirty);
  });

  test('missing legacy tags and unknown enum names are safe', () {
    final input = example().toJson();
    input['category'] = 'unrecognized';
    input['seasons'] = ['spring', 'alien', 123];
    input.remove('occasions');
    final restored = ClothingItem.fromJson(input);
    expect(restored.category, ClothingCategory.other);
    expect(restored.seasons, {ClothingSeason.spring});
    expect(restored.occasions, isEmpty);
  });

  test('required metadata fails clearly instead of becoming a broken item', () {
    final input = example().toJson();
    input['id'] = null;
    expect(() => ClothingItem.fromJson(input), throwsFormatException);
  });

  test('copyWith preserves owner, id and creation time', () {
    final original = example();
    final revised = original.copyWith(
      name: 'Açık mavi gömlek',
      isFavorite: false,
      updatedAt: updated.add(const Duration(days: 1)),
    );
    expect(revised.name, 'Açık mavi gömlek');
    expect(revised.isFavorite, isFalse);
    expect(revised.ownerId, original.ownerId);
    expect(revised.id, original.id);
    expect(revised.createdAt, created);
    expect(revised.seasons, original.seasons);
  });

  test('rejects unsafe ids and photo paths of another item', () {
    expect(() => validateWardrobeId('../demo'), throwsArgumentError);
    expect(() => validateWardrobeId('a/b'), throwsArgumentError);
    validateWardrobeId('firebase-uid_ABC123');
    final invalid = example().copyWith(
      photoPath: 'users/someone-else/wardrobe/garment-01/photo',
    );
    expect(() => validateClothingItem(invalid), throwsArgumentError);
  });
}
