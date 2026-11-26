# Commit #12 — Dolaptaki temiz kıyafetlerle kombin önerisi (v1)

SmartClothes, **kullanıcıya ait kıyafetlerden**, sunucu/API çağrısı olmadan deterministik kombin önerileri hazırlamaya başladı.

## Nasıl çalışıyor?

- `OutfitRecommendationService` her istekte `LaundryAvailabilityService` aracılığıyla yalnızca **temiz kıyafetleri** seçer.
- Bütün öneriler kullanıcının `ownerId` değeriyle eşleşen gerçek `ClothingItem` kayıtlarından oluşur; sahte ürün, stok görseli veya referans katalogdan kopyalanmış kombin kullanılmaz.
- Temiz **üst + alt + ayakkabı**, alternatif olarak **elbise + ayakkabı** birlikte önerilir. Kış/sonbaharda varsa temiz bir dış giyim parçası da eklenebilir.
- Mevsim ve kullanım alanı etiketleri ayarlanmış kıyafetler, seçilen filtreyle çelişiyorsa elenir. Etiketi boş olan kıyafetler tüm filtrelere uygun kabul edilir.
- Favori kıyafetler, mevsim/kullanım eşleşmeleri ve basit nötr/benzer renk uyumu daha yüksek puan alır. En fazla beş farklı kombin gösterilir; eşit puanlar kararlı ID sırasıyla çözülür.
- Kombinler **kalıcı olarak kaydedilmez**. Dolabım ekranından dönüşte veya Kombinleri Yenile tuşuyla veriler yeniden okunur. Yeni kirli işaretlenen parçalar önerilerden çıkar.
- Gerekli üst/alt/ayakkabı parçaları yoksa neden kombin oluşturulamadığı açıklanır.

## Kapsam sınırı

Bu sürüm bir yapay zekâ modeli, hava durumu API’si veya stil tercihlerinden çıkarım yapan ML algoritması değildir. Gardırobun içindeki metadata'ya dayalı **açıklanabilir bir v1 öneri motorudur**. Kullanıcının seçtiği referans görseller kopyalanmaz. Hava durumu, AI ağırlıklı kişiselleştirme, kombin kaydetme ve alışveriş önerileri sonraki commitlerin konusudur.

## Test

`flutter analyze --fatal-infos` ve `flutter test` GitHub Actions üzerinden doğrulanır. Testler gerçek kıyafetlerden kombin oluşturma, temiz/kirli sınırı, eksik parça durumları, sahiplik ayrımı, filtreler, favoriler, sıralama ve dolap değişikliklerine tepkiyi kapsar.
