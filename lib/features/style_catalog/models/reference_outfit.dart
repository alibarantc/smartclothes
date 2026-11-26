import 'package:smartclothes/features/onboarding/models/user_preferences.dart';

/// Curated reference looks with stable identifiers, garment descriptions and
/// original in-app vector illustrations. No third-party product photographs.
class ReferenceOutfit {
  const ReferenceOutfit({
    required this.id,
    required this.title,
    required this.style,
    required this.top,
    required this.bottom,
    required this.shoes,
    required this.outerwear,
    required this.occasion,
    required this.season,
    required this.fit,
    required this.palette,
    required this.topColor,
    required this.bottomColor,
    required this.layerColor,
  });

  final String id;
  final String title;
  final ClothingStyle style;
  final String top;
  final String bottom;
  final String shoes;
  final String outerwear;
  final String occasion;
  final String season;
  final String fit;
  final String palette;
  final int topColor;
  final int bottomColor;
  final int layerColor;

  String get itemSummary => [top, bottom, shoes, if (outerwear.isNotEmpty) outerwear].join(' · ');
}

/// Exactly 40 fixed reference outfits; ids are persisted as local favorites.
const List<ReferenceOutfit> referenceOutfits = [
  ReferenceOutfit(id: 'minimal-01', title: 'Krem Tonlar', style: ClothingStyle.minimal, top: 'Beyaz basic tişört', bottom: 'Krem düz pantolon', shoes: 'Beyaz sneaker', outerwear: '', occasion: 'günlük', season: 'ilkbahar', fit: 'regular', palette: 'krem / beyaz', topColor: 0xFFF2EEE4, bottomColor: 0xFFD7C9AE, layerColor: 0xFFC9C1B2),
  ReferenceOutfit(id: 'minimal-02', title: 'Monokrom Şehir', style: ClothingStyle.minimal, top: 'Antrasit triko', bottom: 'Siyah bol paça pantolon', shoes: 'Siyah loafer', outerwear: 'Koyu gri palto', occasion: 'şehir', season: 'kış', fit: 'rahat', palette: 'antrasit / siyah', topColor: 0xFF5D6262, bottomColor: 0xFF303335, layerColor: 0xFF424648),
  ReferenceOutfit(id: 'minimal-03', title: 'Sade Yaz', style: ClothingStyle.minimal, top: 'Keten beyaz gömlek', bottom: 'Bej keten şort', shoes: 'Düz sandalet', outerwear: '', occasion: 'tatil', season: 'yaz', fit: 'regular', palette: 'beyaz / bej', topColor: 0xFFF8F5EC, bottomColor: 0xFFD6BD9C, layerColor: 0xFFD3B697),
  ReferenceOutfit(id: 'minimal-04', title: 'Zeytin Denge', style: ClothingStyle.minimal, top: 'Adaçayı kazak', bottom: 'Ekru chino', shoes: 'Kahverengi loafer', outerwear: '', occasion: 'günlük', season: 'sonbahar', fit: 'regular', palette: 'adaçayı / ekru', topColor: 0xFF899B83, bottomColor: 0xFFE5DCC8, layerColor: 0xFF9E8D72),
  ReferenceOutfit(id: 'minimal-05', title: 'Lacivert Çizgi', style: ClothingStyle.minimal, top: 'Lacivert polo', bottom: 'Açık gri pantolon', shoes: 'Beyaz sneaker', outerwear: '', occasion: 'ofis', season: 'dört mevsim', fit: 'regular', palette: 'lacivert / gri', topColor: 0xFF263850, bottomColor: 0xFFBDC1C1, layerColor: 0xFF536478),
  ReferenceOutfit(id: 'minimal-06', title: 'Toprak Katmanlar', style: ClothingStyle.minimal, top: 'Kum rengi triko', bottom: 'Haki pantolon', shoes: 'Süet bot', outerwear: 'Ekru overshirt', occasion: 'hafta sonu', season: 'sonbahar', fit: 'rahat', palette: 'kum / haki', topColor: 0xFFC5B28E, bottomColor: 0xFF626D52, layerColor: 0xFFE2D8C4),
  ReferenceOutfit(id: 'minimal-07', title: 'Siyah Beyaz', style: ClothingStyle.minimal, top: 'Beyaz gömlek', bottom: 'Siyah cigarette pantolon', shoes: 'Siyah sneaker', outerwear: '', occasion: 'günlük', season: 'dört mevsim', fit: 'slim', palette: 'beyaz / siyah', topColor: 0xFFF0F0ED, bottomColor: 0xFF282B2F, layerColor: 0xFFBEBFC0),
  ReferenceOutfit(id: 'classic-01', title: 'Ofis Klasik', style: ClothingStyle.classic, top: 'Mavi Oxford gömlek', bottom: 'Lacivert kumaş pantolon', shoes: 'Deri loafer', outerwear: 'Lacivert blazer', occasion: 'ofis', season: 'dört mevsim', fit: 'regular', palette: 'mavi / lacivert', topColor: 0xFFA6C4D9, bottomColor: 0xFF273A5B, layerColor: 0xFF344B6E),
  ReferenceOutfit(id: 'classic-02', title: 'Zamansız Bej', style: ClothingStyle.classic, top: 'Ekru gömlek', bottom: 'Bej pantolon', shoes: 'Kahve loafer', outerwear: 'Camel trençkot', occasion: 'ofis', season: 'ilkbahar', fit: 'regular', palette: 'ekru / bej', topColor: 0xFFF2E5CD, bottomColor: 0xFFC6AA85, layerColor: 0xFFB78F64),
  ReferenceOutfit(id: 'classic-03', title: 'Kış Klasik', style: ClothingStyle.classic, top: 'Bordo boğazlı kazak', bottom: 'Koyu gri pantolon', shoes: 'Klasik bot', outerwear: 'Kömür palto', occasion: 'ofis', season: 'kış', fit: 'regular', palette: 'bordo / kömür', topColor: 0xFF79384B, bottomColor: 0xFF4A5056, layerColor: 0xFF36383E),
  ReferenceOutfit(id: 'classic-04', title: 'Pazar Şıklığı', style: ClothingStyle.classic, top: 'Çizgili mavi gömlek', bottom: 'Ekru chino', shoes: 'Kahverengi loafer', outerwear: '', occasion: 'hafta sonu', season: 'ilkbahar', fit: 'regular', palette: 'mavi / ekru', topColor: 0xFF86AAB9, bottomColor: 0xFFE7E1D2, layerColor: 0xFFD3BCA6),
  ReferenceOutfit(id: 'classic-05', title: 'Koyu Yeşil', style: ClothingStyle.classic, top: 'Koyu yeşil kazak', bottom: 'Kum chino', shoes: 'Deri sneaker', outerwear: 'Lacivert ceket', occasion: 'ofis', season: 'sonbahar', fit: 'regular', palette: 'yeşil / kum', topColor: 0xFF34594C, bottomColor: 0xFFC9BBA3, layerColor: 0xFF303E52),
  ReferenceOutfit(id: 'classic-06', title: 'Gri Takım', style: ClothingStyle.classic, top: 'Açık gri gömlek', bottom: 'Antrasit pantolon', shoes: 'Siyah Oxford', outerwear: 'Gri blazer', occasion: 'davet', season: 'dört mevsim', fit: 'slim', palette: 'gri / antrasit', topColor: 0xFFC7CBCE, bottomColor: 0xFF44494C, layerColor: 0xFF888C91),
  ReferenceOutfit(id: 'classic-07', title: 'Keten Ofis', style: ClothingStyle.classic, top: 'Beyaz keten gömlek', bottom: 'Taş rengi pantolon', shoes: 'Bej loafer', outerwear: 'Keten blazer', occasion: 'ofis', season: 'yaz', fit: 'rahat', palette: 'beyaz / taş', topColor: 0xFFF5F1E7, bottomColor: 0xFFAEAA9E, layerColor: 0xFFCAC1A9),
  ReferenceOutfit(id: 'street-01', title: 'Sokak Katmanı', style: ClothingStyle.streetwear, top: 'Beyaz oversize tişört', bottom: 'Siyah bol jean', shoes: 'Yüksek taban sneaker', outerwear: 'Yeşil bomber', occasion: 'şehir', season: 'sonbahar', fit: 'oversize', palette: 'beyaz / siyah', topColor: 0xFFF1F1E8, bottomColor: 0xFF25282A, layerColor: 0xFF506B56),
  ReferenceOutfit(id: 'street-02', title: 'Denim Üstüne Denim', style: ClothingStyle.streetwear, top: 'Açık mavi tişört', bottom: 'İndigo baggy jean', shoes: 'Sneaker', outerwear: 'Kot ceket', occasion: 'hafta sonu', season: 'ilkbahar', fit: 'oversize', palette: 'mavi / indigo', topColor: 0xFF9CCCE3, bottomColor: 0xFF284B78, layerColor: 0xFF527DAA),
  ReferenceOutfit(id: 'street-03', title: 'Grafit Sokak', style: ClothingStyle.streetwear, top: 'Grafit hoodie', bottom: 'Gri cargo', shoes: 'Spor sneaker', outerwear: '', occasion: 'şehir', season: 'kış', fit: 'bol', palette: 'grafit / gri', topColor: 0xFF41484F, bottomColor: 0xFF8C9292, layerColor: 0xFF60686A),
  ReferenceOutfit(id: 'street-04', title: 'Kiremit Enerji', style: ClothingStyle.streetwear, top: 'Kiremit oversize tişört', bottom: 'Ekru cargo', shoes: 'Kalın taban sneaker', outerwear: '', occasion: 'hafta sonu', season: 'yaz', fit: 'oversize', palette: 'kiremit / ekru', topColor: 0xFFBD5F44, bottomColor: 0xFFE7DCCB, layerColor: 0xFFC67B5F),
  ReferenceOutfit(id: 'street-05', title: 'Haki Sokak', style: ClothingStyle.streetwear, top: 'Siyah sweatshirt', bottom: 'Haki kargo pantolon', shoes: 'High-top sneaker', outerwear: 'Haki yelek', occasion: 'şehir', season: 'sonbahar', fit: 'oversize', palette: 'siyah / haki', topColor: 0xFF2C2E30, bottomColor: 0xFF647251, layerColor: 0xFF7D8C65),
  ReferenceOutfit(id: 'street-06', title: 'Mor Vurgu', style: ClothingStyle.streetwear, top: 'Lavanta tişört', bottom: 'Koyu jean', shoes: 'Beyaz sneaker', outerwear: 'Siyah ceket', occasion: 'şehir', season: 'ilkbahar', fit: 'bol', palette: 'lavanta / lacivert', topColor: 0xFFB9A4CB, bottomColor: 0xFF303E61, layerColor: 0xFF292D35),
  ReferenceOutfit(id: 'street-07', title: 'Gece Sokak', style: ClothingStyle.streetwear, top: 'Siyah hoodie', bottom: 'Siyah eşofman', shoes: 'Beyaz sneaker', outerwear: 'Gri şişme mont', occasion: 'hafta sonu', season: 'kış', fit: 'oversize', palette: 'siyah / gri', topColor: 0xFF292929, bottomColor: 0xFF3C3B3D, layerColor: 0xFF7F8284),
  ReferenceOutfit(id: 'casual-01', title: 'Günlük Denim', style: ClothingStyle.casual, top: 'Beyaz tişört', bottom: 'Mavi düz jean', shoes: 'Beyaz sneaker', outerwear: '', occasion: 'günlük', season: 'dört mevsim', fit: 'regular', palette: 'beyaz / denim', topColor: 0xFFF4F3EF, bottomColor: 0xFF547CAD, layerColor: 0xFFB3C4CF),
  ReferenceOutfit(id: 'casual-02', title: 'Hafta Sonu Rahat', style: ClothingStyle.casual, top: 'Gri sweatshirt', bottom: 'Krem jogger', shoes: 'Spor sneaker', outerwear: '', occasion: 'hafta sonu', season: 'sonbahar', fit: 'rahat', palette: 'gri / krem', topColor: 0xFF999CA1, bottomColor: 0xFFDBD3C2, layerColor: 0xFFBFBFC0),
  ReferenceOutfit(id: 'casual-03', title: 'Yaz Sahili', style: ClothingStyle.casual, top: 'Turkuaz tişört', bottom: 'Kum şort', shoes: 'Beyaz slip-on', outerwear: '', occasion: 'tatil', season: 'yaz', fit: 'rahat', palette: 'turkuaz / kum', topColor: 0xFF62A5A5, bottomColor: 0xFFD9BE9B, layerColor: 0xFF9AB4B0),
  ReferenceOutfit(id: 'casual-04', title: 'Kahve Molası', style: ClothingStyle.casual, top: 'Karamel triko', bottom: 'Lacivert jean', shoes: 'Deri sneaker', outerwear: '', occasion: 'günlük', season: 'kış', fit: 'regular', palette: 'karamel / lacivert', topColor: 0xFFB67E53, bottomColor: 0xFF2F4768, layerColor: 0xFFC49B72),
  ReferenceOutfit(id: 'casual-05', title: 'Bahar Yağmuru', style: ClothingStyle.casual, top: 'Ekru kazak', bottom: 'Mavi jean', shoes: 'Beyaz sneaker', outerwear: 'Adaçayı yağmurluk', occasion: 'günlük', season: 'ilkbahar', fit: 'regular', palette: 'ekru / mavi', topColor: 0xFFE5DBCA, bottomColor: 0xFF607DA5, layerColor: 0xFF788E77),
  ReferenceOutfit(id: 'casual-06', title: 'Pembe Dokunuş', style: ClothingStyle.casual, top: 'Pudra tişört', bottom: 'Açık renk jean', shoes: 'Beyaz sneaker', outerwear: '', occasion: 'hafta sonu', season: 'yaz', fit: 'regular', palette: 'pudra / mavi', topColor: 0xFFE7B7BA, bottomColor: 0xFF9FB9D7, layerColor: 0xFFF3E0E0),
  ReferenceOutfit(id: 'casual-07', title: 'Retro Günlük', style: ClothingStyle.casual, top: 'Yeşil polo', bottom: 'Koyu denim', shoes: 'Retro sneaker', outerwear: 'Krem hırka', occasion: 'günlük', season: 'sonbahar', fit: 'regular', palette: 'yeşil / denim', topColor: 0xFF5E8158, bottomColor: 0xFF31507A, layerColor: 0xFFD6CCAC),
  ReferenceOutfit(id: 'sporty-01', title: 'Aktif Sabah', style: ClothingStyle.sporty, top: 'Siyah dry-fit tişört', bottom: 'Gri tayt', shoes: 'Koşu ayakkabısı', outerwear: '', occasion: 'spor', season: 'yaz', fit: 'fit', palette: 'siyah / gri', topColor: 0xFF33373C, bottomColor: 0xFF70777E, layerColor: 0xFF8F969C),
  ReferenceOutfit(id: 'sporty-02', title: 'Park Yürüyüşü', style: ClothingStyle.sporty, top: 'Adaçayı sweatshirt', bottom: 'Siyah jogger', shoes: 'Koşu sneaker', outerwear: '', occasion: 'spor', season: 'sonbahar', fit: 'rahat', palette: 'adaçayı / siyah', topColor: 0xFF8A9C8B, bottomColor: 0xFF2D3032, layerColor: 0xFF68766B),
  ReferenceOutfit(id: 'sporty-03', title: 'Tenis İlhamı', style: ClothingStyle.sporty, top: 'Beyaz polo', bottom: 'Lacivert şort', shoes: 'Beyaz spor ayakkabı', outerwear: '', occasion: 'spor', season: 'yaz', fit: 'regular', palette: 'beyaz / lacivert', topColor: 0xFFF1F1E7, bottomColor: 0xFF283C62, layerColor: 0xFF9EAAB8),
  ReferenceOutfit(id: 'sporty-04', title: 'Spor Katman', style: ClothingStyle.sporty, top: 'Füme spor tişört', bottom: 'Haki jogger', shoes: 'Antrenman ayakkabısı', outerwear: 'Siyah fermuarlı üst', occasion: 'spor', season: 'kış', fit: 'fit', palette: 'füme / haki', topColor: 0xFF565E62, bottomColor: 0xFF6A755D, layerColor: 0xFF25282B),
  ReferenceOutfit(id: 'sporty-05', title: 'Renkli Koşu', style: ClothingStyle.sporty, top: 'Mercan üst', bottom: 'Siyah şort', shoes: 'Koşu sneaker', outerwear: '', occasion: 'spor', season: 'yaz', fit: 'fit', palette: 'mercan / siyah', topColor: 0xFFE07D69, bottomColor: 0xFF2E343A, layerColor: 0xFFE7B2A8),
  ReferenceOutfit(id: 'sporty-06', title: 'Hafta Sonu Outdoor', style: ClothingStyle.sporty, top: 'Mavi teknik tişört', bottom: 'Kömür pantolon', shoes: 'Outdoor sneaker', outerwear: 'Haki rüzgarlık', occasion: 'seyahat', season: 'ilkbahar', fit: 'rahat', palette: 'mavi / kömür', topColor: 0xFF397AA8, bottomColor: 0xFF484F54, layerColor: 0xFF879276),
  ReferenceOutfit(id: 'elegant-01', title: 'Akşam Zarafeti', style: ClothingStyle.elegant, top: 'Siyah ipek gömlek', bottom: 'Siyah geniş pantolon', shoes: 'Klasik topuklu', outerwear: 'Siyah blazer', occasion: 'davet', season: 'dört mevsim', fit: 'regular', palette: 'siyah / siyah', topColor: 0xFF26282A, bottomColor: 0xFF303135, layerColor: 0xFF444446),
  ReferenceOutfit(id: 'elegant-02', title: 'Şampanya Tonları', style: ClothingStyle.elegant, top: 'Şampanya bluz', bottom: 'Krem kumaş pantolon', shoes: 'Ten rengi ayakkabı', outerwear: 'Bej blazer', occasion: 'davet', season: 'ilkbahar', fit: 'regular', palette: 'şampanya / krem', topColor: 0xFFE8D4AC, bottomColor: 0xFFE8E0D0, layerColor: 0xFFCBB88F),
  ReferenceOutfit(id: 'elegant-03', title: 'Bordo Gecesi', style: ClothingStyle.elegant, top: 'Bordo saten bluz', bottom: 'Antrasit pantolon', shoes: 'Siyah deri ayakkabı', outerwear: 'Siyah blazer', occasion: 'davet', season: 'kış', fit: 'slim', palette: 'bordo / antrasit', topColor: 0xFF8C3448, bottomColor: 0xFF353A40, layerColor: 0xFF242B32),
  ReferenceOutfit(id: 'elegant-04', title: 'Adaçayı Davet', style: ClothingStyle.elegant, top: 'Adaçayı gömlek', bottom: 'Ekru palazzo', shoes: 'Klasik loafer', outerwear: '', occasion: 'davet', season: 'yaz', fit: 'rahat', palette: 'adaçayı / ekru', topColor: 0xFF9BAF99, bottomColor: 0xFFE5DDCB, layerColor: 0xFFB6C0AB),
  ReferenceOutfit(id: 'elegant-05', title: 'Gece Mavisi', style: ClothingStyle.elegant, top: 'Gece mavisi bluz', bottom: 'Siyah kumaş pantolon', shoes: 'Siyah ayakkabı', outerwear: 'Lacivert blazer', occasion: 'davet', season: 'sonbahar', fit: 'regular', palette: 'gece mavisi / siyah', topColor: 0xFF253B63, bottomColor: 0xFF26292B, layerColor: 0xFF223653),
  ReferenceOutfit(id: 'elegant-06', title: 'Modern Monokrom', style: ClothingStyle.elegant, top: 'Beyaz saten gömlek', bottom: 'Kömür palazzo', shoes: 'Klasik ayakkabı', outerwear: 'Gri ceket', occasion: 'davet', season: 'dört mevsim', fit: 'rahat', palette: 'beyaz / kömür', topColor: 0xFFF4F0E7, bottomColor: 0xFF454A4F, layerColor: 0xFF797F83),
];
