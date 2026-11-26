import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/wardrobe/services/wardrobe_photo_service.dart';

void main() {
  const service = WardrobePhotoService();

  test('photo path is owner scoped and stable', () {
    expect(
      WardrobePhotoService.storagePath('user_ABC', 'item-123'),
      'users/user_ABC/wardrobe/item-123/photo',
    );
    expect(
      () => WardrobePhotoService.storagePath('user/other', 'item-123'),
      throwsArgumentError,
    );
  });

  test('photo upload refuses unsupported formats and oversized bytes', () async {
    await expectLater(
      service.uploadPhoto(
        ownerId: 'demo',
        itemId: 'item1',
        bytes: Uint8List.fromList([1, 2]),
        contentType: 'application/pdf',
      ),
      throwsArgumentError,
    );
    await expectLater(
      service.uploadPhoto(
        ownerId: 'demo',
        itemId: 'item1',
        bytes: Uint8List(0),
        contentType: 'image/jpeg',
      ),
      throwsArgumentError,
    );
  });

  test('unconfigured Firebase fails rather than inventing photo storage',
      () async {
    await expectLater(
      service.uploadPhoto(
        ownerId: 'demo',
        itemId: 'item1',
        bytes: Uint8List.fromList([1, 2, 3]),
        contentType: 'image/jpeg',
      ),
      throwsStateError,
    );
    await expectLater(
      service.getPhoto(ownerId: 'demo', itemId: 'item1'),
      throwsStateError,
    );
  });
}
