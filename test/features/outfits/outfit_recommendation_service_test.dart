import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/outfits/services/outfit_recommendation_service.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';

void main() {
  const engine = OutfitRecommendationService();
  final timestamp = DateTime.utc(2026, 11, 26);

  ClothingItem item(
    String id,
    ClothingCategory category, {
    String owner = 'demo',
    String color = 'siyah',
    LaundryStatus status = LaundryStatus.clean,
    bool favorite = false,
    Set<ClothingSeason> seasons = const {},
    Set<ClothingOccasion> occasions = const {},
  }) =>
      ClothingItem(
        id: id,
        ownerId: owner,
        name: id,
        category: category,
        color: color,
        isFavorite: favorite,
        seasons: seasons,
        occasions: occasions,
        laundryStatus: status,
        createdAt: timestamp,
        updatedAt: timestamp,
      );

  test('builds outfits only from actually owned tops, bottoms and shoes', () {
    final clothes = [
      item('tee', ClothingCategory.tops, color: 'beyaz'),
      item('jean', ClothingCategory.bottoms, color: 'lacivert'),
      item('sneaker', ClothingCategory.shoes, color: 'beyaz'),
    ];
    final results = engine.recommend(ownerId: 'demo', wardrobe: clothes);
    expect(results, hasLength(1));
    expect(results.single.items.map((e) => e.id).toSet(),
        {'tee', 'jean', 'sneaker'});
    expect(results.single.reasons, contains('Dolabındaki temiz kıyafetlerden'));
  });

  test('dirty garments can never participate or be substituted', () {
    final wardrobe = [
      item('tee', ClothingCategory.tops),
      item('trousers', ClothingCategory.bottoms),
      item('dirty-shoes', ClothingCategory.shoes,
          status: LaundryStatus.dirty),
    ];
    expect(engine.recommend(ownerId: 'demo', wardrobe: wardrobe), isEmpty);
    wardrobe.add(item('clean-shoes', ClothingCategory.shoes));
    final outfits = engine.recommend(ownerId: 'demo', wardrobe: wardrobe);
    expect(outfits, hasLength(1));
    expect(outfits.single.items.map((e) => e.id), isNot(contains('dirty-shoes')));
  });

  test('does not mix clothing from different users', () {
    final results = engine.recommend(ownerId: 'demo', wardrobe: [
      item('top', ClothingCategory.tops),
      item('bottom', ClothingCategory.bottoms),
      item('other-shoes', ClothingCategory.shoes, owner: 'other'),
    ]);
    expect(results, isEmpty);
  });

  test('dress with shoes works without separate top and bottom', () {
    final results = engine.recommend(ownerId: 'demo', wardrobe: [
      item('dress', ClothingCategory.dresses),
      item('heels', ClothingCategory.shoes),
    ]);
    expect(results, hasLength(1));
    expect(results.single.items.map((e) => e.id).toSet(),
        {'dress', 'heels'});
  });

  test('cold weather layer is included only when owned and clean', () {
    final wardrobe = [
      item('top', ClothingCategory.tops),
      item('bottom', ClothingCategory.bottoms),
      item('shoes', ClothingCategory.shoes),
      item('coat', ClothingCategory.outerwear),
      item('dirty-coat', ClothingCategory.outerwear,
          status: LaundryStatus.dirty),
    ];
    final cold = engine.recommend(ownerId: 'demo', wardrobe: wardrobe,
        season: ClothingSeason.winter);
    expect(cold, hasLength(1));
    expect(cold.single.items.map((item) => item.id), contains('coat'));
    expect(cold.single.items.map((item) => item.id),
        isNot(contains('dirty-coat')));

    final warm = engine.recommend(ownerId: 'demo', wardrobe: wardrobe,
        season: ClothingSeason.summer);
    expect(warm.single.items.map((item) => item.id), isNot(contains('coat')));
  });

  test('filters only known conflicting seasons and occasions', () {
    final wardrobe = [
      item('summer-top', ClothingCategory.tops,
          seasons: {ClothingSeason.summer},
          occasions: {ClothingOccasion.everyday}),
      item('winter-top', ClothingCategory.tops,
          seasons: {ClothingSeason.winter},
          occasions: {ClothingOccasion.work}),
      item('trousers', ClothingCategory.bottoms),
      item('shoes', ClothingCategory.shoes),
    ];
    final summer = engine.recommend(ownerId: 'demo', wardrobe: wardrobe,
        season: ClothingSeason.summer,
        occasion: ClothingOccasion.everyday);
    expect(summer, hasLength(1));
    expect(summer.single.items.first.id, 'summer-top');

    final winter = engine.recommend(ownerId: 'demo', wardrobe: wardrobe,
        season: ClothingSeason.winter,
        occasion: ClothingOccasion.work);
    expect(winter, hasLength(1));
    expect(winter.single.items.first.id, 'winter-top');
  });

  test('favorites influence score, output order is deterministic', () {
    final items = [
      item('top-b', ClothingCategory.tops, color: 'kırmızı'),
      item('top-a', ClothingCategory.tops, color: 'beyaz', favorite: true),
      item('pants', ClothingCategory.bottoms, color: 'lacivert'),
      item('shoe', ClothingCategory.shoes, color: 'gri'),
    ];
    final first = engine.recommend(ownerId: 'demo', wardrobe: items);
    final reversed = engine.recommend(
        ownerId: 'demo', wardrobe: items.reversed);
    expect(first, hasLength(2));
    expect(first.first.items.first.id, 'top-a');
    expect(first.map((item) => item.id).toList(),
        reversed.map((item) => item.id).toList());
    expect(first.first.score, greaterThan(first.last.score));
    expect(first.first.reasons, contains('Favori parçan kullanıldı'));
  });

  test('result count is limited and combination ids are distinct', () {
    final wardrobe = [
      for (var i = 0; i < 4; i++) item('top$i', ClothingCategory.tops),
      for (var i = 0; i < 3; i++) item('bottom$i', ClothingCategory.bottoms),
      for (var i = 0; i < 2; i++) item('shoe$i', ClothingCategory.shoes),
    ];
    final results =
        engine.recommend(ownerId: 'demo', wardrobe: wardrobe, limit: 5);
    expect(results, hasLength(5));
    expect(results.map((outfit) => outfit.id).toSet(), hasLength(5));
    expect(
      engine.recommend(ownerId: 'demo', wardrobe: wardrobe, limit: 0),
      isEmpty,
    );
  });

  test('empty and incomplete wardrobes yield no invented items', () {
    expect(engine.recommend(ownerId: 'demo', wardrobe: []), isEmpty);
    expect(engine.recommend(ownerId: 'demo', wardrobe: [
      item('top', ClothingCategory.tops),
      item('shoes', ClothingCategory.shoes),
    ]), isEmpty);
  });

  test('switching an item from clean to dirty removes its outfits', () {
    final top = item('top', ClothingCategory.tops);
    final trousers = item('trousers', ClothingCategory.bottoms);
    final sneakers = item('sneakers', ClothingCategory.shoes);
    expect(engine.recommend(ownerId: 'demo',
        wardrobe: [top, trousers, sneakers]), hasLength(1));
    expect(engine.recommend(ownerId: 'demo',
        wardrobe: [top.copyWith(laundryStatus: LaundryStatus.dirty),
          trousers, sneakers]), isEmpty);
  });
}
