# Commit #08 — Kişisel stil profili

Stil profili, kullanıcının `UserPreferences.favoriteOutfitIds` içinde cihazda sakladığı referans kombin kimliklerinden **her görüntülemede yeniden hesaplanır**. İkinci bir kalıcı profil kaydı veya Firebase senkronizasyonu yoktur.

`StyleProfileService.analyze` saf, deterministik bir algoritmadır:

1. Tekrarlanan kimlikleri tekilleştirir ve katalogda bulunmayanları yok sayar.
2. Her geçerli kombin stil puanına bir oy verir. Stil ağırlığı = stilin kombin sayısı / analiz edilen kombin sayısı.
3. `palette` alanını `/` karakterinden ayrıştırır; her renk tek bir kombinde yalnızca bir kez sayılır.
4. `fit` ve `occasion` etiketlerini sayar. Renk, kalıp ve kullanım alanları önce sıklığa, eşitlikte alfabetik sıraya göre sıralanır. Stil eşitliklerinde enum sırası kullanılır.
5. Analiz için en az **beş geçerli** referans kombin gerekir. Daha azında Profil ekranı seçim çağrısı gösterir, sonuç uydurmaz.

Profil ekranındaki **Stil Analizim** alanı seçilen kombin sayısını, baskın tarzı, diğer tarzların yüzdelik paylarını ve en sık görülen renk/kalıp/kullanım alanı etiketlerini gösterir. Favoriler Profil > Beğendiğin Kombinler üzerinden değiştirildiğinde aynı kayıt yeniden okunur ve analiz güncellenir.

Bu sürüm bir yapay zekâ modeli, alışveriş verisi veya gardıroptaki gerçek kıyafetler üzerinde öneri sistemi değildir. Analiz, yalnızca seçilen 40 referans kombinin metadata etiketlerini özetler.
