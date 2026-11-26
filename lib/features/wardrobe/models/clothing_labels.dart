import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';

extension ClothingCategoryLabel on ClothingCategory {
  String get label => switch (this) {
        ClothingCategory.tops => 'Üst Giyim',
        ClothingCategory.bottoms => 'Alt Giyim',
        ClothingCategory.outerwear => 'Dış Giyim',
        ClothingCategory.dresses => 'Elbise',
        ClothingCategory.shoes => 'Ayakkabı',
        ClothingCategory.accessories => 'Aksesuar',
        ClothingCategory.other => 'Diğer',
      };
  String get iconLabel => switch (this) {
        ClothingCategory.tops => 'Tişört',
        ClothingCategory.bottoms => 'Pantolon',
        ClothingCategory.outerwear => 'Ceket',
        ClothingCategory.dresses => 'Elbise',
        ClothingCategory.shoes => 'Ayakkabı',
        ClothingCategory.accessories => 'Aksesuar',
        ClothingCategory.other => 'Kıyafet',
      };
}

extension ClothingSeasonLabel on ClothingSeason {
  String get label => switch (this) {
        ClothingSeason.spring => 'İlkbahar',
        ClothingSeason.summer => 'Yaz',
        ClothingSeason.autumn => 'Sonbahar',
        ClothingSeason.winter => 'Kış',
      };
}

extension ClothingOccasionLabel on ClothingOccasion {
  String get label => switch (this) {
        ClothingOccasion.everyday => 'Günlük',
        ClothingOccasion.work => 'İş / Okul',
        ClothingOccasion.formal => 'Özel Gün',
        ClothingOccasion.sport => 'Spor',
        ClothingOccasion.travel => 'Seyahat',
      };
}
