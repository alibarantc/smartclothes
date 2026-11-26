import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/repositories/local_wardrobe_repository.dart';

void main() {
  const store = LocalWardrobeRepository();
  final created = DateTime.utc(2026, 11, 26);

  ClothingItem item({
    String id = 'shirt1',
    String ownerId = 'demo',
    String name = 'Beyaz tişört',
  }) =>
      ClothingItem(
        id: id,
        ownerId: ownerId,
        name: name,
        category: ClothingCategory.tops,
        color: 'beyaz',
        createdAt: created,
        updatedAt: created,
      );

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('local wardrobe saves, updates and removes metadata', () async {
    expect(await store.listItems('demo'), isEmpty);
    await store.saveItem(item());
    expect((await store.listItems('demo')).single.name, 'Beyaz tişört');
    await store.saveItem(item(name: 'Ekru tişört'));
    expect(await store.listItems('demo'), hasLength(1));
    expect((await store.listItems('demo')).single.name, 'Ekru tişört');
    await store.deleteItem('demo', 'shirt1');
    expect(await store.listItems('demo'), isEmpty);
  });

  test('laundry status survives a local save, reload and update', () async {
    await store.saveItem(item().copyWith(laundryStatus: LaundryStatus.dirty));
    expect((await store.listItems('demo')).single.laundryStatus,
        LaundryStatus.dirty);
    final reloaded = (await store.listItems('demo')).single;
    await store.saveItem(reloaded.copyWith(laundryStatus: LaundryStatus.clean));
    expect((await store.listItems('demo')).single.laundryStatus,
        LaundryStatus.clean);
  });

  test('demo account never leaks to another account', () async {
    await store.saveItem(item());
    await store.saveItem(item(id: 'shirt2', ownerId: 'userABC'));
    expect((await store.listItems('demo')).single.id, 'shirt1');
    expect((await store.listItems('userABC')).single.id, 'shirt2');
    await store.deleteItem('userABC', 'shirt1');
    expect(await store.listItems('demo'), hasLength(1));
  });

  test('malformed local JSON cannot crash wardrobe', () async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(store.storageKey('demo'), 'bad-json');
    expect(await store.listItems('demo'), isEmpty);
    await preferences.setString(store.storageKey('demo'), '{}');
    expect(await store.listItems('demo'), isEmpty);
  });

  test('corrupt entries and cross-account records are ignored', () async {
    final preferences = await SharedPreferences.getInstance();
    final badOwner = item(ownerId: 'another').toJson();
    await preferences.setString(
      store.storageKey('demo'),
      jsonEncode([{'name': 12}, badOwner]),
    );
    expect(await store.listItems('demo'), isEmpty);
  });

  test('metadata only, no image bytes are written to local preferences',
      () async {
    final clothing = item();
    await store.saveItem(clothing);
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(store.storageKey('demo'))!;
    expect(raw, contains('"photoPath":null'));
    expect(raw, isNot(contains('"imageBytes"')));
  });
}
