# SmartClothes — Commit #09: Dijital gardırop veri altyapısı

Bu commit **metadata ve özel kıyafet fotoğrafı için depolama katmanı** sağlar. Kıyafet ekleme, fotoğraf seçimi, düzenleme ve silme ekranları Commit #10 kapsamında yapılacaktır.

## Veri modeli

`ClothingItem` şu alanları tutar: `id`, `ownerId`, `name`, `category`, `color`, `seasons`, `occasions`, isteğe bağlı `brand`, `notes`, `photoPath`, `isFavorite`, `createdAt`, `updatedAt`. Mevsim ve kullanım alanı alanları enum kümesidir. Tarihler JSON'da Unix epoch milisaniyesi olarak saklanır. Fotoğraf verisi modele gömülmez.

## Çalışma şekli

- `LocalWardrobeRepository`: Firebase gerektirmeyen, hesap kimliğine göre ayrılmış, yalnızca cihazda SharedPreferences üzerinde metadata tutan demo altyapısı. Fotoğraf **baytları** SharedPreferences'a yazılmaz.
- `FirestoreWardrobeRepository`: `users/{uid}/wardrobeItems/{itemId}` altında bulutta metadata tutar. Firebase bağlantısı yoksa sessizce başarılı dönmek yerine hata verir. Yetkilendirme Firestore kurallarında sağlanır.
- `WardrobePhotoService`: JPEG, PNG ve WebP türünde, 8 MiB veya daha küçük fotoğrafları `users/{uid}/wardrobe/{itemId}/photo` özel Storage nesnesine yükler. Nesne yolunu metadata'da saklamak üzere döndürür; indirilebilir **kalıcı URL** üretmez. Okuma/silme de bu owner-scoped yoldan yapılır. Firebase bağlantısı yoksa yükleme devre dışıdır.

## Güvenlik

`firestore.rules` ve `storage.rules`, yalnızca kimlik doğrulaması yapılmış **kendi uid** yoluna erişime izin verir; diğer koleksiyon ve Storage yollarına erişim kapalıdır. Storage yüklemeleri 8 MiB ve izin verilen resim MIME türleriyle sınırlanır. Bu kuralların canlı Firebase projesinde kullanılması için Firebase konsolunda proje bağlantısı ve ayrı `firebase deploy --only firestore:rules,storage` adımı gereklidir; repo commit'i kuralları kendiliğinden dağıtmaz.

## Sınırlar

Henüz gerçek Firebase projesi bağlanmadı, canlı yükleme doğrulanmadı. Demo modunda metadata saklanır; fotoğraf yükleme için gerçek Firebase/oturum gerekir. İleride CRUD ekranı, izinler, fotoğraf seçimi ve temizleme yaşam döngüsü Commit #10'da tamamlanacaktır.
