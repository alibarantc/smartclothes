import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/outfits/presentation/outfits_screen.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/repositories/local_wardrobe_repository.dart';

void main() {
  const repo = LocalWardrobeRepository();
  final now = DateTime.utc(2026, 11, 26);

  ClothingItem garment(String id, ClothingCategory category, {
    LaundryStatus status = LaundryStatus.clean,
    Set<ClothingSeason> seasons = const <ClothingSeason>{},
  }) => ClothingItem(
    id: id,
    ownerId: 'demo',
    name: id,
    category: category,
    color: 'siyah',
    seasons: seasons,
    laundryStatus: status,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: OutfitsScreen(ownerId: 'demo', repository: repo),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('explains missing items without inventing a combination',
      (tester) async {
    await open(tester);
    expect(find.text('Henüz oluşturulmuş bir kombin yok'), findsOneWidget);
    expect(find.text('Önce Dolabım ekranına kıyafetlerini ekle.'),
        findsOneWidget);
    expect(find.byKey(const ValueKey('outfit-suggestion-count')), findsNothing);
  });

  testWidgets('shows only clean owned garments from the local wardrobe',
      (tester) async {
    await repo.saveItem(garment('Temiz gömlek', ClothingCategory.tops));
    await repo.saveItem(garment('Koyu pantolon', ClothingCategory.bottoms));
    await repo.saveItem(garment('Temiz ayakkabı', ClothingCategory.shoes));
    await repo.saveItem(garment('Kirli gömlek', ClothingCategory.tops,
        status: LaundryStatus.dirty));
    await open(tester);
    expect(find.text('1 kombin önerisi'), findsOneWidget);
    expect(find.textContaining('Temiz gömlek'), findsOneWidget);
    expect(find.textContaining('Koyu pantolon'), findsOneWidget);
    expect(find.textContaining('Temiz ayakkabı'), findsOneWidget);
    expect(find.textContaining('Kirli gömlek'), findsNothing);
  });

  testWidgets('refresh button reads laundry changes from the repository',
      (tester) async {
    final shirt = garment('shirt', ClothingCategory.tops);
    await repo.saveItem(shirt);
    await repo.saveItem(garment('pants', ClothingCategory.bottoms));
    await repo.saveItem(garment('shoes', ClothingCategory.shoes));
    await open(tester);
    expect(find.text('1 kombin önerisi'), findsOneWidget);

    await repo.saveItem(shirt.copyWith(laundryStatus: LaundryStatus.dirty));
    await tester.tap(find.byKey(const ValueKey('reload-outfit-suggestions')));
    await tester.pumpAndSettle();
    expect(find.text('1 kombin önerisi'), findsNothing);
    expect(find.text('Henüz oluşturulmuş bir kombin yok'), findsOneWidget);
    expect(find.text('Temiz üst + alt veya elbise ekle.'), findsOneWidget);
  });

  testWidgets('season filter removes known incompatible pieces',
      (tester) async {
    await repo.saveItem(garment('Yaz gömleği', ClothingCategory.tops,
        seasons: {ClothingSeason.summer}));
    await repo.saveItem(garment('Kış kazağı', ClothingCategory.tops,
        seasons: {ClothingSeason.winter}));
    await repo.saveItem(garment('Pantolon', ClothingCategory.bottoms));
    await repo.saveItem(garment('Ayakkabı', ClothingCategory.shoes));
    await open(tester);
    expect(find.text('2 kombin önerisi'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('outfits-season-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yaz').last);
    await tester.pumpAndSettle();
    expect(find.text('1 kombin önerisi'), findsOneWidget);
    expect(find.textContaining('Yaz gömleği'), findsOneWidget);
    expect(find.textContaining('Kış kazağı'), findsNothing);
  });
}
