import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';

/// Offline demo repository for garment metadata (never photo bytes).
///
/// Data is isolated per user id and persisted only on this device. This does
/// not pretend to upload to Firebase or synchronize across devices.
class LocalWardrobeRepository implements WardrobeRepository {
  const LocalWardrobeRepository();

  String storageKey(String ownerId) {
    validateWardrobeId(ownerId);
    return 'smartclothes.wardrobe.v1.${Uri.encodeComponent(ownerId)}';
  }

  @override
  Future<List<ClothingItem>> listItems(String ownerId) async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(storageKey(ownerId));
    if (raw == null) return <ClothingItem>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <ClothingItem>[];
      final items = <ClothingItem>[];
      for (final value in decoded) {
        if (value is! Map<String, dynamic>) continue;
        try {
          final item = ClothingItem.fromJson(value);
          if (item.ownerId == ownerId) items.add(item);
        } on FormatException {
          // A bad legacy entry should not prevent reading valid garments.
        }
      }
      return _sorted(items);
    } on FormatException {
      return <ClothingItem>[];
    }
  }

  @override
  Future<void> saveItem(ClothingItem item) async {
    validateClothingItem(item);
    final preferences = await SharedPreferences.getInstance();
    final items = await listItems(item.ownerId);
    items.removeWhere((entry) => entry.id == item.id);
    items.add(item);
    final saved = await preferences.setString(
      storageKey(item.ownerId),
      jsonEncode(_sorted(items).map((entry) => entry.toJson()).toList()),
    );
    if (!saved) throw StateError('Could not save wardrobe locally');
  }

  @override
  Future<void> deleteItem(String ownerId, String itemId) async {
    validateWardrobeId(ownerId);
    validateWardrobeId(itemId);
    final preferences = await SharedPreferences.getInstance();
    final items = await listItems(ownerId);
    items.removeWhere((entry) => entry.id == itemId);
    if (!await preferences.setString(
        storageKey(ownerId),
        jsonEncode(items.map((entry) => entry.toJson()).toList()))) {
      throw StateError('Could not delete wardrobe item locally');
    }
  }

  static List<ClothingItem> _sorted(List<ClothingItem> items) {
    return items..sort((a, b) {
      final byUpdate = b.updatedAt.compareTo(a.updatedAt);
      return byUpdate != 0 ? byUpdate : a.id.compareTo(b.id);
    });
  }
}
