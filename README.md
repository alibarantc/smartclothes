# SmartClothes 👕✨

**SmartClothes**, kullanıcının kıyafetlerini dijital gardırobunda yönetmesini, kendi stiline ve hava durumuna uygun kombinler oluşturmasını ve gardırobunda eksik olan parçaları keşfetmesini amaçlayan **kişiselleştirilmiş mobil stil asistanıdır**.

> **Proje durumu:** 🟡 Planlama / tasarım aşaması. Aşağıda belirtilen özellikler ürün gereksinimlerini ifade eder; henüz tamamlanmış işlevler olarak değerlendirilmemelidir.

## 🎯 Projenin amacı

“Bugün ne giysem?” sorusuna, kullanıcıya ait gerçek gardırop verilerini dikkate alan öneriler sunmak.

SmartClothes; **stil tercihleri + mevcut kıyafetler + kıyafetlerin temizlik durumu + güncel hava durumu** verilerini birlikte değerlendirir. Alışveriş önerileri ise yalnızca gardıropta gerçekten faydalı bir eksik parça tespit edildiğinde gösterilir.

## ✨ Planlanan temel özellikler

### 1. Kişisel stil profili — 40 kombinlik başlangıç kataloğu
- İlk kullanımda, farklı tarz ve renk kombinasyonlarını temsil eden **40 referans kombin** sunulur.
- Kullanıcı beğendiği kombinlerden **en az 5 tanesini** seçer.
- Seçimler; stil, renk, kesim ve kullanım amacı gibi etiketlerden oluşan bir tercih profiline dönüştürülür.
- Profil daha sonra değiştirilebilir; uygulama içindeki beğeni / beğenmeme geri bildirimleriyle öneriler gelişir.
- Referans kombinler **satın alınacak zorunlu ürünler** değil, kullanıcının zevkini anlamaya yarayan örneklerdir.

### 2. Dijital gardırop
- Kamera veya galeriden kıyafet fotoğrafı ekleme.
- Kategori (üst, alt, ayakkabı, dış giyim, aksesuar), alt kategori, renk, mevsim ve kullanım amacı bilgilerini kaydetme.
- Kıyafet görüntüleme, arama, filtreleme, düzenleme ve silme.
- Kıyafetlerden manuel kombin oluşturma ve kombinleri favorilere kaydetme.

### 3. Otomatik hava durumu
- Uygulama, **kullanıcının iznini alarak** cihazın konumuyla hava durumunu öğrenir; şehir veya sıcaklık bilgisini elle girmesi gerekmez.
- Sıcaklık ve hava koşulları kombin önerilerinde kullanılır.
- Konum izni reddedilirse **manuel şehir seçme** alternatifi sunulur.
- İlk sürümde sürekli arka plan konum takibi hedeflenmez; yalnızca ihtiyaç duyulduğunda konum alınır.

### 4. Temiz / kirli kıyafet takibi 🧺
- Her kıyafet **Temiz** veya **Kirli** durumunda tutulur.
- Kirli kıyafetler gardıropta görünmeye devam eder ancak otomatik kombin önerilerinden çıkarılır.
- Ayrı bir **Kirli Sepeti** üzerinden kıyafetler topluca temiz olarak işaretlenebilir.
- **Bugün Giydim** işlemi sonrasında kombin parçalarını kirli olarak işaretleme seçeneği sunulur.
- Giyilme ve yıkanma tarihleri ileride istatistiklerde kullanılabilecek şekilde saklanabilir.
- **Önemli:** Kullanıcının sahip olduğu ancak kirli olan kıyafet, *alışverişte eksik parça* sayılmaz.

### 5. Kişiselleştirilmiş kombin önerileri
Öneri motoru şu ölçütleri birleştirir:

| Ölçüt | Kullanımı |
| --- | --- |
| Stil profili | Kullanıcının başlangıçta seçtiği ve sonradan beğendiği stillere uyum |
| Gardırop | Kullanıcının gerçekten sahip olduğu parçalar |
| Temizlik durumu | Kirli parçaların öneri dışı bırakılması |
| Hava durumu | Sıcaklık ve hava koşullarına uygunluk |
| Renk / kategori uyumu | Birlikte giyilebilir parçaların eşleştirilmesi |
| Etkinlik türü | Günlük, okul, spor, özel gün gibi bağlamlar |

İlk aşamada **içerik tabanlı / kural destekli bir öneri sistemi** geliştirilecektir. Sistem, hazır 40 kombini aynen tekrar etmek yerine bunları stil referansı olarak kullanarak **kullanıcının kendi kıyafetlerinden** kombinler üretir. İleride görsel analiz veya ek yapay zekâ modelleri entegre edilebilir.

### 6. Stil Kutusu — eksik parça ve alışveriş önerileri 📬
Uygulamanın ana sayfasında posta kutusuna benzeyen bir **Stil Kutusu** yer alır.

Örnek mesaj:

> **Gardırobunda bir parça eksik olabilir!**  
> Beyaz basic tişört, sevdiğin minimalist kombinlere uyabilir. Dolabında benzer bir parça bulunmuyor. Mavi, Koton veya H&M gibi mağazalarda bu ürünü arayabilirsin.

**Öneri sıklığı:**
- **İlk kullanım:** Stil seçimi ve gardırop girişi tamamlandıktan sonra yapılan ilk analizde **5–10 anlamlı eksik parça** önerisi hedeflenir.
- **Sonraki haftalar:** Haftada **1–2 yeni alışveriş önerisi** hedeflenir.
- Gerçekten faydalı bir eksik bulunmuyorsa sırf sayıyı doldurmak için öneri üretilmez.
- Aynı parça tekrar tekrar önerilmez; reddedilen veya gardıroba eklenen öneriler dikkate alınır.
- Stil Kutusu içindeki mesajlar uygulama üzerinden görülebilir; telefon bildirimleri isteğe bağlıdır.

Kullanıcı önerileri **alışveriş listesine kaydedebilir**, **gizleyebilir** veya satın aldığı parçayı **gardırobuna ekleyebilir**.

### 7. Bütçe ve marka tercihleri 💸
Kullanıcı alışveriş önerileri için şu bütçe profillerinden birini seçebilir:
- **Ekonomik**
- **Orta / fiyat-performans**
- **Premium**
- **Fark etmez**

İsteğe bağlı olarak **kıyafet başına maksimum bütçe** de belirleyebilir.

İlk sürümde gerçek zamanlı fiyat ve stok verisi bulunmayacağı için bütçe eşleşmesi, markaların **yaklaşık fiyat segmentleri** üzerinden yapılacaktır; bu, kesin bir fiyat sınırı garantisi değildir.

Marka havuzu; global markaların yanı sıra Türkiye'de faaliyet gösteren yerli markaları da içerecek şekilde genişletilebilir. Örnekler: **Zara, H&M, Mango, Mavi, Koton, DeFacto, LC Waikiki, Colin's, Lufian, AVVA, OXXO, İpekyol, Kiğılı, Altınyıldız Classics**.

Marka önerileri yalnızca **ürün kategorisi, stil ve bütçeye göre nerelere bakılabileceğine ilişkin yönlendirmeler** olacak; ilk sürümde canlı ürün kataloğu, fiyat karşılaştırma, uygulama içi satış veya marka ortaklığı bulunmayacaktır.

## 📱 Tasarlanan ekranlar

1. Açılış / tanıtım (Splash & Onboarding)
2. Giriş ve kayıt
3. Başlangıç stil seçimi (40 referans kombin)
4. Ana sayfa (hava durumu + günlük kombin + Stil Kutusu özeti)
5. Dolabım (listeleme ve filtreler)
6. Kıyafet ekle / kıyafet detayı
7. Kombin oluşturucu
8. Akıllı kombin önerileri
9. Favori kombinler
10. Kirli Sepeti
11. Stil Kutusu
12. Alışveriş Listem
13. Profil ve ayarlar (stil, bütçe, bildirim tercihleri)

## 🛠️ Planlanan teknoloji altyapısı

| Katman | Planlanan teknoloji |
| --- | --- |
| Mobil uygulama | **Flutter / Dart** |
| Kimlik doğrulama | **Firebase Authentication** |
| Veritabanı | **Cloud Firestore** |
| Kıyafet fotoğrafları | **Firebase Storage** |
| Konum izni ve koordinat | **geolocator** (Flutter) |
| Hava durumu | **WeatherAPI** veya **OpenWeatherMap** (seçilecek) |
| Durum yönetimi | **Provider** (ilk tercih; değişebilir) |
| Öneri motoru | İçerik tabanlı / kural destekli puanlama |

> Bunlar **mimari önerileridir**; geliştirme ve testler ilerledikçe değişebilir.

## 🗃️ Ön veri modeli (taslak)

- **users:** Profil, stil tercihleri, bütçe, bildirim ve izin tercihleri.
- **style_reference_outfits:** Başlangıçta gösterilen 40 kombin ve stil etiketleri.
- **clothes:** Kullanıcıya ait kıyafetler, görsel bağlantıları, kategoriler ve temizlik durumu.
- **outfits:** Oluşturulan kombinler ve içerdiği kıyafet kimlikleri.
- **outfit_feedback:** Önerilere verilen beğeni / beğenmeme geri bildirimi.
- **shopping_suggestions:** Eksik parça önerileri, gerekçeleri, durumları ve gösterim tarihleri.
- **shopping_list:** Kullanıcının kaydettiği parçalar.
- **brands:** Mağaza/marka kategorileri ve yaklaşık bütçe segmentleri.

Bu şema uygulama geliştirilirken kesinleştirilecektir. Kullanıcı verileri kullanıcı kimliğiyle ilişkilendirilecek, uygun erişim kuralları tanımlanacaktır.

## 🗺️ Geliştirme yol haritası

| Aşama | İşler | Durum |
| --- | --- | --- |
| 1 | Ürün gereksinimleri ve README | 🟡 Devam ediyor |
| 2 | Flutter proje iskeleti, tema ve navigasyon | ⬜ Planlandı |
| 3 | Firebase kurulumu, kullanıcı hesapları | ⬜ Planlandı |
| 4 | Stil kataloğu ve başlangıç tercihi analizi | ⬜ Planlandı |
| 5 | Dijital gardırop ve temiz/kirli takibi | ⬜ Planlandı |
| 6 | Konum izni, hava durumu ve kombin motoru | ⬜ Planlandı |
| 7 | Stil Kutusu, haftalık öneriler ve bütçe ayarları | ⬜ Planlandı |
| 8 | Test, güvenlik kontrolleri, hata düzeltme ve demo | ⬜ Planlandı |

**Geliştirme yaklaşımı:** Tek seferde devasa kod üretimi yerine, her ekranı ve özelliği küçük, test edilebilir adımlarla tasarlayıp geliştirmek.

## 🔐 Gizlilik, içerik hakları ve ticari taraf

- Konum bilgisi izinle alınır; izin verilmemesi temel gardırop kullanımını engellemez.
- Fotoğraflar ve gardırop verileri için uygun erişim kontrolleri ve veri silme akışları tasarlanır.
- Başlangıçtaki 40 stil görseli ve diğer görseller, uygun kullanım haklarıyla temin edilir veya özgün olarak üretilir.
- İlk sürümde üçüncü taraf mağazaların ürün görselleri/logoları izinsiz kopyalanmaz; mağazalar **arayabileceğin yerler** olarak sunulur.
- Marka isimlerinin gösterilmesi bir sponsorluk veya resmî ortaklık anlamına gelmez.
- Gelecekte ticari iş birlikleri yapılırsa reklam/sponsorluk ilişkisi açıkça belirtilir.

## 🔮 İleride değerlendirilebilecek özellikler

- Marka iş birlikleri ve **yetkili** ürün kataloğu entegrasyonları.
- Fiyat, stok ve ürün bağlantısı önerileri.
- Fotoğraftan kıyafet türü / renk tanıma.
- Fotoğrafların arka planını kaldırma.
- Takvim üzerinden kombin planlama.
- Giyilme sıklığı ve gardırop kullanım istatistikleri.
- Valiz hazırlama asistanı.

---

### ℹ️ Geliştirme notu

Bu depo, SmartClothes'un **erken aşama ürün dokümantasyonunu** barındırmaktadır. Henüz çalıştırılabilir Flutter uygulaması veya kurulum talimatları yayımlanmamıştır. Kod eklendiğinde kurulum, yapılandırma, ekran görüntüleri ve test adımları bu README'ye eklenecektir.

**SmartClothes — Dolabını tanır, tarzını öğrenir.**
