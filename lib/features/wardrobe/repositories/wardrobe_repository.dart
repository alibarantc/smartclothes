import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';

/// Metadata persistence contract. Photo upload is a separate operation.
abstract class WardrobeRepository {
  Future<List<ClothingItem>> listItems(String ownerId);
  Future<void> saveItem(ClothingItem item);
  Future<void> deleteItem(String ownerId, String itemId);
}

/// Reject invalid path segments before they reach Firestore or Firebase Storage.
void validateWardrobeId(String id) {
  if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id) || id.length > 128) {
    throw ArgumentError.value(id, 'id', 'Invalid wardrobe id');
  }
}

void validateClothingItem(ClothingItem item) {
  validateWardrobeId(item.id);
  validateWardrobeId(item.ownerId);
  if (item.name.trim().isEmpty || item.name.length > 120 ||
      item.color.trim().isEmpty || item.color.length > 60 ||
      (item.brand?.length ?? 0) > 120 ||
      (item.notes?.length ?? 0) > 1000) {
    throw ArgumentError('Invalid clothing item fields');
  }
  if (item.updatedAt.isBefore(item.createdAt)) {
    throw ArgumentError('updatedAt cannot precede createdAt');
  }
  final cloudPath = 'users/${item.ownerId}/wardrobe/${item.id}/photo';
  final localPath = 'local/wardrobe/${item.ownerId}/${item.id}/photo';
  if (item.photoPath != null &&
      item.photoPath != cloudPath &&
      item.photoPath != localPath) {
    throw ArgumentError('Photo path does not belong to this item');
  }
}
