import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartclothes/core/services/firebase/firestore_service.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';

/// Owner-scoped cloud metadata. Firestore rules enforce request.auth.uid.
///
/// Without Firebase configuration, this repository fails clearly rather than
/// silently claiming that a cloud write succeeded.
class FirestoreWardrobeRepository implements WardrobeRepository {
  const FirestoreWardrobeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db {
    final instance = _firestore ?? FirestoreService.instance;
    if (instance == null) {
      throw StateError('Firebase bağlantısı yok; bulut gardırobu kullanılamıyor.');
    }
    return instance;
  }

  CollectionReference<Map<String, dynamic>> _items(String ownerId) {
    validateWardrobeId(ownerId);
    return _db.collection('users').doc(ownerId).collection('wardrobeItems');
  }

  @override
  Future<List<ClothingItem>> listItems(String ownerId) async {
    final snapshot = await _items(ownerId).get();
    final items = <ClothingItem>[];
    for (final document in snapshot.docs) {
      try {
        final item = ClothingItem.fromJson(document.data());
        if (item.ownerId == ownerId && item.id == document.id) items.add(item);
      } on FormatException {
        // Ignore malformed legacy records rather than crashing the wardrobe.
      }
    }
    items.sort((a, b) {
      final updated = b.updatedAt.compareTo(a.updatedAt);
      return updated != 0 ? updated : a.id.compareTo(b.id);
    });
    return items;
  }

  @override
  Future<void> saveItem(ClothingItem item) async {
    validateClothingItem(item);
    await _items(item.ownerId).doc(item.id).set(item.toJson());
  }

  @override
  Future<void> deleteItem(String ownerId, String itemId) async {
    validateWardrobeId(itemId);
    await _items(ownerId).doc(itemId).delete();
  }
}
