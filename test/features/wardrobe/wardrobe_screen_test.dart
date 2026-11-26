import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/presentation/clothing_item_editor_screen.dart';
import 'package:smartclothes/features/wardrobe/presentation/wardrobe_screen.dart';
import 'package:smartclothes/features/wardrobe/repositories/local_wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/services/wardrobe_image_store.dart';

class _MemoryImages implements WardrobeImageStore {
  final Map<String, Uint8List> saved = {};
  int deleted = 0;

  String _path(String ownerId, String itemId) =>
      'local/wardrobe/$ownerId/$itemId/photo';

  @override
  Future<String> save({
    required String ownerId,
    required String itemId,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final key = _path(ownerId, itemId);
    saved[key] = bytes;
    return key;
  }

  @override
  Future<Uint8List?> read({
    required String ownerId,
    required String itemId,
  }) async => saved[_path(ownerId, itemId)];

  @override
  Future<void> delete({
    required String ownerId,
    required String itemId,
  }) async {
    saved.remove(_path(ownerId, itemId));
    deleted++;
  }
}

void main() {
  const repo = LocalWardrobeRepository();
  late _MemoryImages images;
  final timestamp = DateTime.utc(2026, 11, 26);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    images = _MemoryImages();
  });

  Future<void> render(
    WidgetTester tester, {
    Future<PickedWardrobePhoto?> Function()? picker,
  }) async {
    await tester.pumpWidget(MaterialApp(
      home: WardrobeScreen(
        ownerId: 'demo',
        repository: repo,
        images: images,
        pickPhoto: picker,
      ),
    ));
    await tester.pumpAndSettle();
  }

  ClothingItem garment(String id, String name,
          {ClothingCategory category = ClothingCategory.tops,
           String color = 'beyaz',
           bool favorite = false}) =>
      ClothingItem(
        id: id,
        ownerId: 'demo',
        name: name,
        category: category,
        color: color,
        isFavorite: favorite,
        createdAt: timestamp,
        updatedAt: timestamp,
      );

  testWidgets('empty wardrobe can add, edit, and delete a garment',
      (tester) async {
    await render(tester);
    expect(find.text('Dolabın henüz boş'), findsOneWidget);
    await tester.tap(find.text('İlk Kıyafetini Ekle'));
    await tester.pumpAndSettle();
    expect(find.byType(ClothingItemEditorScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('save-garment')));
    await tester.pumpAndSettle();
    expect(find.text('Bu alan zorunlu'), findsWidgets);

    await tester.enterText(
        find.byKey(const ValueKey('garment-name')), 'Beyaz tişört');
    await tester.enterText(
        find.byKey(const ValueKey('garment-color')), 'Beyaz');
    await tester.tap(find.byKey(const ValueKey('save-garment')));
    await tester.pumpAndSettle();
    expect(find.text('Beyaz tişört'), findsOneWidget);
    expect((await repo.listItems('demo')).single.name, 'Beyaz tişört');

    await tester.tap(find.text('Beyaz tişört'));
    await tester.pumpAndSettle();
    expect(find.text('Kıyafeti Düzenle'), findsOneWidget);
    await tester.enterText(
        find.byKey(const ValueKey('garment-name')), 'Ekru tişört');
    // Hide the test keyboard so it cannot obscure the fixed save action.
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-garment')));
    await tester.pumpAndSettle();
    expect(find.byType(ClothingItemEditorScreen), findsNothing);
    expect(find.text('Ekru tişört'), findsOneWidget);
    expect(await repo.listItems('demo'), hasLength(1));

    final menu = find.byType(PopupMenuButton<String>);
    expect(menu, findsOneWidget);
    await tester.tap(menu);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sil').last);
    await tester.pumpAndSettle();
    expect(find.text('Kıyafet silinsin mi?'), findsOneWidget);
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    expect(await repo.listItems('demo'), hasLength(1));

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sil').last);
    await tester.pumpAndSettle();
    expect(await repo.listItems('demo'), isEmpty);
    expect(find.text('Dolabın henüz boş'), findsOneWidget);
  });

  testWidgets('search, category and favorites filter persisted garments',
      (tester) async {
    await repo.saveItem(garment('one', 'Mavi Gömlek', color: 'mavi'));
    await repo.saveItem(garment('two', 'Siyah Ayakkabı',
        category: ClothingCategory.shoes, color: 'siyah',
        favorite: true));
    await render(tester);
    expect(find.text('Mavi Gömlek'), findsOneWidget);
    expect(find.text('Siyah Ayakkabı'), findsOneWidget);
    await tester.enterText(
        find.byKey(const ValueKey('wardrobe-search')), 'Mavi');
    await tester.pumpAndSettle();
    expect(find.text('Mavi Gömlek'), findsOneWidget);
    expect(find.text('Siyah Ayakkabı'), findsNothing);
    await tester.enterText(
        find.byKey(const ValueKey('wardrobe-search')), '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favoriler'));
    await tester.pumpAndSettle();
    expect(find.text('Mavi Gömlek'), findsNothing);
    expect(find.text('Siyah Ayakkabı'), findsOneWidget);
    await tester.tap(find.text('Favoriler'));
    await tester.pumpAndSettle();
    // Category chips are horizontally scrollable and offscreen chips are lazy.
    await tester.drag(find.byType(ListView).first, const Offset(-380, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ayakkabı'));
    await tester.pumpAndSettle();
    expect(find.text('Mavi Gömlek'), findsNothing);
    expect(find.text('Siyah Ayakkabı'), findsOneWidget);
  });

  testWidgets('photo bytes are stored separately, then cleaned on delete',
      (tester) async {
    // A valid tiny PNG avoids codec failures when Image.memory decodes it.
    final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Y9i8pgAAAAASUVORK5CYII=',
    );
    await render(tester, picker: () async =>
        PickedWardrobePhoto(bytes: bytes, contentType: 'image/png'));
    await tester.tap(find.text('İlk Kıyafetini Ekle'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('garment-name')), 'Fotoğraflı kazak');
    await tester.enterText(
        find.byKey(const ValueKey('garment-color')), 'Gri');
    await tester.tap(find.text('Fotoğraf Seç'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-garment')));
    await tester.pumpAndSettle();

    final item = (await repo.listItems('demo')).single;
    expect(item.photoPath,
        'local/wardrobe/demo/${item.id}/photo');
    expect(images.saved, hasLength(1));
    expect(find.text('Fotoğraflı kazak'), findsOneWidget);

    await tester.tap(find.byTooltip('Kıyafet işlemleri'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sil').last);
    await tester.pumpAndSettle();
    expect(images.saved, isEmpty);
    expect(images.deleted, 1);
  });
}
