import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/services/wardrobe_photo_service.dart';

/// Separate photo bytes from wardrobe metadata and account preferences.
abstract class WardrobeImageStore {
  Future<String> save({
    required String ownerId,
    required String itemId,
    required Uint8List bytes,
    required String contentType,
  });

  Future<Uint8List?> read({required String ownerId, required String itemId});

  Future<void> delete({required String ownerId, required String itemId});
}

class LocalWardrobeImageStore implements WardrobeImageStore {
  const LocalWardrobeImageStore({this.rootProvider});

  /// Injectable app-documents directory for deterministic unit tests.
  final Future<Directory> Function()? rootProvider;

  static String photoPath(String ownerId, String itemId) {
    validateWardrobeId(ownerId);
    validateWardrobeId(itemId);
    return 'local/wardrobe/$ownerId/$itemId/photo';
  }

  Future<File> _file(String ownerId, String itemId) async {
    photoPath(ownerId, itemId);
    final root = rootProvider == null
        ? await getApplicationDocumentsDirectory()
        : await rootProvider!();
    return File('${root.path}/smartclothes/wardrobe/$ownerId/$itemId/photo');
  }

  @override
  Future<String> save({
    required String ownerId,
    required String itemId,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final path = photoPath(ownerId, itemId);
    if (bytes.isEmpty || bytes.lengthInBytes > WardrobePhotoService.maxPhotoBytes) {
      throw ArgumentError('Photo size must be between 1 byte and 8 MiB');
    }
    if (contentType != 'image/jpeg' &&
        contentType != 'image/png' &&
        contentType != 'image/webp') {
      throw ArgumentError.value(contentType, 'contentType', 'Unsupported image type');
    }
    final file = await _file(ownerId, itemId);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return path;
  }

  @override
  Future<Uint8List?> read({
    required String ownerId,
    required String itemId,
  }) async {
    final file = await _file(ownerId, itemId);
    if (!await file.exists()) return null;
    if (await file.length() > WardrobePhotoService.maxPhotoBytes) {
      throw StateError('Stored photo exceeds maximum size');
    }
    return file.readAsBytes();
  }

  @override
  Future<void> delete({
    required String ownerId,
    required String itemId,
  }) async {
    final file = await _file(ownerId, itemId);
    if (await file.exists()) await file.delete();
  }
}

class CloudWardrobeImageStore implements WardrobeImageStore {
  const CloudWardrobeImageStore({this.service = const WardrobePhotoService()});

  final WardrobePhotoService service;

  @override
  Future<String> save({
    required String ownerId,
    required String itemId,
    required Uint8List bytes,
    required String contentType,
  }) => service.uploadPhoto(
        ownerId: ownerId, itemId: itemId,
        bytes: bytes, contentType: contentType,
      );

  @override
  Future<Uint8List?> read({
    required String ownerId,
    required String itemId,
  }) => service.getPhoto(ownerId: ownerId, itemId: itemId);

  @override
  Future<void> delete({
    required String ownerId,
    required String itemId,
  }) => service.deletePhoto(ownerId: ownerId, itemId: itemId);
}

class WardrobeImageStoreFactory {
  const WardrobeImageStoreFactory._();

  static WardrobeImageStore forCurrentSession({AuthService? authService}) {
    final auth = authService ?? AuthService.instance;
    if (auth.isDemoMode.value) return const LocalWardrobeImageStore();
    if (auth.currentUser != null && auth.isFirebaseAvailable) {
      return const CloudWardrobeImageStore();
    }
    throw StateError('Fotoğraf saklamak için giriş yap veya demo modunu aç.');
  }
}
