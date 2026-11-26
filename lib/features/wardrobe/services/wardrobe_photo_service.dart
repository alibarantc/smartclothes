import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartclothes/core/services/firebase/storage_service.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';

/// Upload and retrieve private wardrobe photos. Persist returned object paths
/// in ClothingItem.photoPath, never a public download URL or the photo bytes.
class WardrobePhotoService {
  const WardrobePhotoService({FirebaseStorage? storage}) : _storage = storage;

  final FirebaseStorage? _storage;
  static const int maxPhotoBytes = 8 * 1024 * 1024;

  FirebaseStorage get _client {
    final storage = _storage ?? StorageService.instance;
    if (storage == null) {
      throw StateError('Firebase Storage bağlı değil; fotoğraf yüklenemiyor.');
    }
    return storage;
  }

  static String storagePath(String ownerId, String itemId) {
    validateWardrobeId(ownerId);
    validateWardrobeId(itemId);
    return 'users/$ownerId/wardrobe/$itemId/photo';
  }

  Future<String> uploadPhoto({
    required String ownerId,
    required String itemId,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final path = storagePath(ownerId, itemId);
    if (bytes.isEmpty || bytes.lengthInBytes > maxPhotoBytes) {
      throw ArgumentError('Photo size must be between 1 byte and 8 MiB');
    }
    if (contentType != 'image/jpeg' &&
        contentType != 'image/png' &&
        contentType != 'image/webp') {
      throw ArgumentError.value(contentType, 'contentType', 'Unsupported image type');
    }
    await _client.ref(path).putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );
    return path;
  }

  Future<Uint8List?> getPhoto({
    required String ownerId,
    required String itemId,
  }) async {
    return _client.ref(storagePath(ownerId, itemId)).getData(maxPhotoBytes);
  }

  /// Delete is explicit. Removing metadata alone does not delete a photo.
  Future<void> deletePhoto({
    required String ownerId,
    required String itemId,
  }) async {
    try {
      await _client.ref(storagePath(ownerId, itemId)).delete();
    } on FirebaseException catch (error) {
      if (error.code != 'object-not-found') rethrow;
    }
  }
}
