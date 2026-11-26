# SmartClothes — Commit #10: Gardırop yönetimi

Bu sürüm, Commit #09'daki kıyafet modeli ve depolama altyapısını ilk gerçek **Dolabım** kullanıcı deneyimine bağlar.

- Kıyafet adı ve renk zorunludur; kategori, mevsim, kullanım alanı, marka, not ve favori alanları düzenlenebilir.
- Kıyafetler listelenebilir, isme/renge/markaya göre aranabilir, kategorilere ve favorilere göre filtrelenebilir.
- Düzenleme ve silme işlemleri için arayüz vardır; silmeden önce onay istenir.
- Fotoğraf arşivinden JPEG/PNG/WebP seçilebilir. En fazla 8 MiB; seçilen görsel en çok 1600px kenar uzunluğunda işlenmeye çalışılır. Galeri erişim izni iOS Info.plist'te açıklanır.
- Demo modunda metadata `LocalWardrobeRepository` ile SharedPreferences üzerinde, fotoğraf **baytları** ise `path_provider` aracılığıyla cihazdaki uygulama belgeleri dizininde saklanır; hesap kimlikleri ayrıdır.
- Gerçek oturumda metadata `FirestoreWardrobeRepository`, fotoğraflar özel `WardrobePhotoService` aracılığıyla Firebase Storage üzerinde tutulur. Gerçek Firebase hesabı/Storage yapılandırması olmadığında bulut kaydı mümkün değildir.
- Fotoğraflar içeriklerine göre `Image.memory` ile görüntülenir; public URL oluşturulmaz. Kıyafet silindiğinde metadata silinip fotoğraf temizliği denenir; temizlik başarısızsa kullanıcıya ayrı uyarı gösterilir.
- Bu sürümde otomatik renk/etiket çıkarımı veya AI entegrasyonu **yoktur**. Veri kaydı da canlı Firebase'e bağlanmış değildir.

## Çalıştırma

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test
```

Gerçek cihazda galeri seçimi ve Firebase erişim kuralları ayrıca doğrulanmalıdır. Sıfırdan kurulumda demo modunu açıp Dolabım > İlk Kıyafetini Ekle üzerinden kullanabilirsin.
