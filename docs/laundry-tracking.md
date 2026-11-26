# SmartClothes — Commit #11: Çamaşır Takibi

Bu sürümde her `ClothingItem`, `laundryStatus` alanıyla **clean / dirty** durumunu tutar.

- Yeni kıyafetler varsayılan olarak **Temiz** kaydedilir. Eski yerel/Firestore kayıtlarında alan bulunmuyorsa geçmiş kayıtlar **Temiz** kabul edilir. Alanın tanınmayan bir değeri varsa kombinlere yanlışlıkla eklememek için **Kirli** kabul edilir.
- Kullanıcı Dolabım ekranında **Temiz: N · Kirli: N** sayacını görür; **Temiz** veya **Kirli** filtresini uygulayabilir.
- Kıyafet satırındaki çamaşır simgesinden hızlıca **Kirli İşaretle** / **Temiz İşaretle** değişikliği yapabilir. Düzenleme formunda da “Bu kıyafet kirli” seçeneği bulunur.
- Her değişiklik mevcut demo depolamasına veya bağlıysa Firestore'a kaydedilir. `updatedAt` yenilenir ve kıyafet silinmez.
- `LaundryAvailabilityService.eligibleForOutfits` yalnızca **temiz kıyafetleri** kombin adayları olarak döndürür. `missingItemIds` tüm sahip olunan kıyafetleri esas alır: kirli parça **eksik sayılmaz**.
- Firestore kuralları `laundryStatus` alanını yalnızca `clean` veya `dirty` olarak kabul eder. Kuralın canlı Firebase'e uygulanması için manuel `firebase deploy --only firestore:rules` gerekir.

**Sınır:** Bu commit, veri modelini ve gelecekteki öneri motorunun kullanacağı uygunluk filtresini hazırlar; SmartClothes'ta henüz otomatik kombin oluşturma motoru bulunmadığı için gerçek öneri sonuçlarını değiştirdiği iddia edilmez.

Kontroller:

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test
```

Unit, widget, yerel kayıt ve sahte Firestore testlerinde temiz-kirli geçişleri, eski kayıtlar ve kirli kıyafetin eksik sayılmaması doğrulanır.
