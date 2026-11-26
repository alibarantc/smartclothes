import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/wardrobe/services/wardrobe_image_store.dart';

void main() {
  late Directory root;
  late LocalWardrobeImageStore images;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('smartclothes-photo-test-');
    images = LocalWardrobeImageStore(rootProvider: () async => root);
  });

  tearDown(() async {
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('stores and reads private app-document photo bytes', () async {
    final photo = Uint8List.fromList([1, 2, 3, 4]);
    final key = await images.save(
      ownerId: 'demo', itemId: 'item_1',
      bytes: photo, contentType: 'image/png',
    );
    expect(key, 'local/wardrobe/demo/item_1/photo');
    expect(await images.read(ownerId: 'demo', itemId: 'item_1'), photo);
    expect(await images.read(ownerId: 'another', itemId: 'item_1'), isNull);
    await images.delete(ownerId: 'demo', itemId: 'item_1');
    expect(await images.read(ownerId: 'demo', itemId: 'item_1'), isNull);
    // Multiple deletes are safe.
    await images.delete(ownerId: 'demo', itemId: 'item_1');
  });

  test('rejects unsafe paths, unsupported formats and empty files', () async {
    expect(
      () => LocalWardrobeImageStore.photoPath('../demo', 'item_1'),
      throwsArgumentError,
    );
    await expectLater(
      images.save(
        ownerId: 'demo', itemId: 'a',
        bytes: Uint8List(0), contentType: 'image/jpeg',
      ),
      throwsArgumentError,
    );
    await expectLater(
      images.save(
        ownerId: 'demo', itemId: 'a',
        bytes: Uint8List.fromList([1, 2]), contentType: 'image/gif',
      ),
      throwsArgumentError,
    );
  });

  test('a different account cannot read the first account photos', () async {
    await images.save(
      ownerId: 'user_one', itemId: 'item',
      bytes: Uint8List.fromList([1]), contentType: 'image/png',
    );
    await images.save(
      ownerId: 'user_two', itemId: 'item',
      bytes: Uint8List.fromList([2]), contentType: 'image/png',
    );
    expect(await images.read(ownerId: 'user_one', itemId: 'item'), [1]);
    expect(await images.read(ownerId: 'user_two', itemId: 'item'), [2]);
  });
}
