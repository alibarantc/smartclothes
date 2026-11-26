import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/presentation/clothing_item_editor_screen.dart';
import 'package:smartclothes/features/wardrobe/presentation/wardrobe_screen.dart';
import 'package:smartclothes/features/wardrobe/repositories/local_wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/services/wardrobe_image_store.dart';

class _UnusedImages implements WardrobeImageStore {
  const _UnusedImages();

  @override
  Future<String> save({
    required String ownerId,
    required String itemId,
    required Uint8List bytes,
    required String contentType,
  }) async => throw StateError('No image expected in laundry tests');

  @override
  Future<Uint8List?> read({
    required String ownerId,
    required String itemId,
  }) async => null;

  @override
  Future<void> delete({
    required String ownerId,
    required String itemId,
  }) async {}
}

void main() {
  const repo = LocalWardrobeRepository();
  final now = DateTime.utc(2026, 11, 26);

  ClothingItem garment(
    String id,
    String name, {
    LaundryStatus laundryStatus = LaundryStatus.clean,
  }) =>
      ClothingItem(
        id: id,
        ownerId: 'demo',
        name: name,
        category: ClothingCategory.tops,
        color: 'mavi',
        laundryStatus: laundryStatus,
        createdAt: now,
        updatedAt: now,
      );

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> render(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: WardrobeScreen(
        ownerId: 'demo',
        repository: repo,
        images: _UnusedImages(),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('filters clean and dirty garments without losing inventory',
      (tester) async {
    await repo.saveItem(garment('clean1', 'Beyaz tişört'));
    await repo.saveItem(garment('dirty1', 'Siyah pantolon',
        laundryStatus: LaundryStatus.dirty));

    await render(tester);
    expect(find.text('Temiz: 1 · Kirli: 1'), findsOneWidget);
    expect(find.text('Beyaz tişört'), findsOneWidget);
    expect(find.text('Siyah pantolon'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('laundry-filter-dirty')));
    await tester.pumpAndSettle();
    expect(find.text('Beyaz tişört'), findsNothing);
    expect(find.text('Siyah pantolon'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('laundry-filter-clean')));
    await tester.pumpAndSettle();
    expect(find.text('Beyaz tişört'), findsOneWidget);
    expect(find.text('Siyah pantolon'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('laundry-filter-clean')));
    await tester.pumpAndSettle();
    expect(find.text('Siyah pantolon'), findsOneWidget);
  });

  testWidgets('quick mark as dirty and back as clean persists', (tester) async {
    await repo.saveItem(garment('shirt1', 'Günlük gömlek'));
    await render(tester);

    final toggle = find.byKey(const ValueKey('toggle-laundry-shirt1'));
    expect(find.byTooltip('Kirli İşaretle'), findsOneWidget);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect((await repo.listItems('demo')).single.laundryStatus,
        LaundryStatus.dirty);
    expect(find.text('Temiz: 0 · Kirli: 1'), findsOneWidget);
    expect(find.byTooltip('Temiz İşaretle'), findsOneWidget);

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect((await repo.listItems('demo')).single.laundryStatus,
        LaundryStatus.clean);
    expect(find.text('Temiz: 1 · Kirli: 0'), findsOneWidget);
  });

  testWidgets('editor can save a dirty item as clean', (tester) async {
    await repo.saveItem(garment('coat1', 'Yün ceket',
        laundryStatus: LaundryStatus.dirty));
    await render(tester);
    await tester.tap(find.text('Yün ceket'));
    await tester.pumpAndSettle();
    expect(find.byType(ClothingItemEditorScreen), findsOneWidget);

    final statusField = find.byKey(const ValueKey('garment-laundry-status'));
    await tester.ensureVisible(statusField);
    await tester.pumpAndSettle();
    final before = tester.widget<SwitchListTile>(statusField);
    expect(before.value, isTrue);
    await tester.tap(statusField);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(statusField).value, isFalse);

    await tester.tap(find.byKey(const ValueKey('save-garment')));
    await tester.pumpAndSettle();
    expect(find.byType(ClothingItemEditorScreen), findsNothing);
    expect((await repo.listItems('demo')).single.laundryStatus,
        LaundryStatus.clean);
  });
}
