import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/repositories/firestore_wardrobe_repository.dart';

void main() {
  final created = DateTime.utc(2026, 11, 26);

  ClothingItem item({String owner = 'user1', String id = 'item1'}) =>
      ClothingItem(
        id: id,
        ownerId: owner,
        name: 'Gri kazak',
        category: ClothingCategory.tops,
        color: 'gri',
        seasons: const {ClothingSeason.winter},
        occasions: const {ClothingOccasion.everyday},
        createdAt: created,
        updatedAt: created,
      );

  test('Firestore repository stores garment metadata under owner path',
      () async {
    final fake = FakeFirebaseFirestore();
    final repo = FirestoreWardrobeRepository(firestore: fake);
    await repo.saveItem(item());

    final raw = await fake
        .collection('users')
        .doc('user1')
        .collection('wardrobeItems')
        .doc('item1')
        .get();
    expect(raw.exists, isTrue);
    expect(raw.data()?['ownerId'], 'user1');
    expect(raw.data()?['name'], 'Gri kazak');

    final loaded = await repo.listItems('user1');
    expect(loaded, hasLength(1));
    expect(loaded.single.seasons, {ClothingSeason.winter});
    expect(await repo.listItems('user2'), isEmpty);

    await repo.deleteItem('user1', 'item1');
    expect(await repo.listItems('user1'), isEmpty);
  });

  test('bad records and mismatched document ids are ignored', () async {
    final fake = FakeFirebaseFirestore();
    final repo = FirestoreWardrobeRepository(firestore: fake);
    final col = fake.collection('users').doc('user1').collection('wardrobeItems');
    await col.doc('wrong').set(item().toJson());
    await col.doc('broken').set({'invalid': true});
    expect(await repo.listItems('user1'), isEmpty);
  });

  test('unsafe document identifiers are rejected', () async {
    final fake = FakeFirebaseFirestore();
    final repo = FirestoreWardrobeRepository(firestore: fake);
    expect(() => repo.saveItem(item(id: 'abc/123')), throwsArgumentError);
    expect(() => repo.deleteItem('user1', '../item'), throwsArgumentError);
  });

  test('unconfigured Firestore never claims a successful write', () async {
    const repo = FirestoreWardrobeRepository();
    await expectLater(repo.listItems('demo'), throwsStateError);
    await expectLater(repo.saveItem(item()), throwsStateError);
  });
}
