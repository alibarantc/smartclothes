# SmartClothes — Firebase Kurulum Kılavuzu

> [!IMPORTANT]
> SmartClothes uygulaması Firebase yapılandırması **olmadan da eksiksiz çalışır**. Ana ekran, dolap, kombinler ve profil ekranları demo/çevrimdışı modda sorunsuz açılır. Bulut özellikleri (kullanıcı hesabı, gardırop senkronizasyonu, fotoğraf yükleme) aktif edilmek istendiğinde bu kılavuzdaki adımlar takip edilmelidir.

---

## İçindekiler

1. [Firebase Projesi Oluşturma](#1-firebase-projesi-oluşturma)
2. [Android ve iOS Uygulamalarını Kaydetme](#2-android-ve-ios-uygulamalarını-kaydetme)
3. [FlutterFire CLI Kurulumu](#3-flutterfire-cli-kurulumu)
4. [flutterfire configure İşlemi](#4-flutterfire-configure-işlemi)
5. [Firebase Authentication Kurulumu](#5-firebase-authentication-kurulumu)
6. [Cloud Firestore Kurulumu](#6-cloud-firestore-kurulumu)
7. [Firebase Storage Kurulumu ve Faturalandırma](#7-firebase-storage-kurulumu-ve-faturalandırma)
8. [Güvenlik Kurallarını Dağıtma (Deploy)](#8-güvenlik-kurallarını-dağıtma-deploy)
9. [Yerel Geliştirme (Local Development)](#9-yerel-geliştirme-local-development)
10. [GitHub Actions ve CI Yapılandırması](#10-github-actions-ve-ci-yapılandırması)
11. [Firebase Bağlantısını Doğrulama](#11-firebase-bağlantısını-doğrulama)

---

## 1. Firebase Projesi Oluşturma

1. Tarayıcınızda [https://console.firebase.google.com](https://console.firebase.google.com) adresini açın ve Google hesabınızla giriş yapın.
2. **Proje Ekle** (Add project) butonuna tıklayın.
3. Proje adını girin (Örn: `smartclothes-app` veya `smartclothes-dev`).
4. Google Analytics adımını isteğe bağlı olarak etkinleştirin veya şimdilik kapatın.
5. **Proje Oluştur** butonuna tıklayın ve Firebase'in ortamı hazırlamasını bekleyin.

---

## 2. Android ve iOS Uygulamalarını Kaydetme

SmartClothes projesinin paket kimliği her iki platformda da `com.example.smartclothes` olarak tanımlıdır.

### Android Yapılandırması
1. Firebase Console ana sayfasında **Android simgesine** tıklayın.
2. **Android paket adı**: `com.example.smartclothes` girin.
3. Uygulama takma adı (isteğe bağlı): `SmartClothes Android`.
4. `google-services.json` yapılandırma dosyasını indirin.
5. Dosyayı projenin `android/app/google-services.json` konumuna yerleştirin.

> [!CAUTION]
> `google-services.json` dosyası hassas API anahtarları içerir. Bu dosya `.gitignore` listesindedir; **kesinlikle GitHub'a commit etmeyin**.

### iOS Yapılandırması
1. Firebase Console'da **Uygulama Ekle → iOS** seçin.
2. **iOS bundle kimliği**: `com.example.smartclothes` girin.
3. `GoogleService-Info.plist` yapılandırma dosyasını indirin.
4. Dosyayı projenin `ios/Runner/GoogleService-Info.plist` konumuna yerleştirin.

> [!CAUTION]
> `GoogleService-Info.plist` dosyası `.gitignore` listesindedir; **kesinlikle GitHub'a commit etmeyin**.

---

## 3. FlutterFire CLI Kurulumu

FlutterFire CLI, Firebase yapılandırmasını otomatik olarak yönetir.

1. **Firebase CLI Kurulumu:**
   Node.js kurulu ise terminalden çalıştırın:
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

2. **FlutterFire CLI Kurulumu:**
   ```bash
   dart pub global activate flutterfire_cli
   ```

3. **PATH Ayarı (Gerekirse):**
   - Windows PowerShell:
     ```powershell
     $env:PATH += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
     ```
   - macOS / Linux:
     ```bash
     export PATH="$PATH:$HOME/.pub-cache/bin"
     ```

---

## 4. `flutterfire configure` İşlemi

Proje kök dizininde şu komutu çalıştırın:

```bash
flutterfire configure
```

Bu komut:
- Firebase hesabınızdaki projeleri listeler; oluşturduğunuz `smartclothes-app` projesini seçin.
- Desteklenecek platformları seçmenizi ister: `android` ve `ios` seçin.
- Platform kayıtlarını doğrular ve `lib/firebase_options.dart` dosyasını oluşturur.

Oluşturulan `lib/firebase_options.dart` dosyasını `lib/core/config/firebase_config.dart` içine bağlayabilirsiniz:

```dart
// lib/core/config/firebase_config.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:smartclothes/firebase_options.dart';

class FirebaseConfig {
  FirebaseConfig._();

  static FirebaseOptions? get currentPlatformOptions =>
      DefaultFirebaseOptions.currentPlatform;

  static bool get isConfigured => true;
}
```

---

## 5. Firebase Authentication Kurulumu

SmartClothes kullanıcı hesapları, e-posta ve şifre kimlik doğrulaması üzerinden çalışır.

1. Firebase Console sol menüsünden **Build → Authentication** bölümüne gidin.
2. İlk kez açıyorsanız **Başlayın** (Get started) butonuna tıklayın.
3. **Sign-in method** (Oturum açma yöntemi) sekmesine geçin.
4. Sağlayıcılar listesinden **Email/Password** (E-posta/Şifre) seçeneğine tıklayın.
5. İlk anahtar olan **Email/Password** seçeneğini etkinleştirin (Enable).
6. "Email link (passwordless sign-in)" seçeneğini kapalı bırakın.
7. **Kaydet** (Save) butonuna basarak ayarı uygulayın.

Bu adım tamamlandıktan sonra, `AuthService` sınıfı üzerinden e-posta/şifre ile kayıt, giriş ve şifre sıfırlama işlemleri otomatik olarak aktif hale gelir.

---

## 6. Cloud Firestore Kurulumu

1. Firebase Console sol menüsünden **Build → Firestore Database** bölümüne gidin.
2. **Veritabanı Oluştur** (Create database) butonuna tıklayın.
3. **Üretim Modunda Başlat** (Start in production mode) seçeneğini seçin (Varsayılan olarak tüm erişimleri engeller).
4. Veritabanı konumunu seçin (Örn: Türkiye için `europe-west3` Frankfurt veya `europe-west1` Belçika).
5. **Etkinleştir** butonuna tıklayın.

---

## 7. Firebase Storage Kurulumu ve Faturalandırma

Kıyafet fotoğraflarının saklanması için Cloud Storage kullanılır.

1. Firebase Console sol menüsünden **Build → Storage** bölümüne gidin.
2. **Başlayın** (Get started) butonuna tıklayın.
3. **Üretim Modu** seçin ve Firestore ile aynı bölgeyi belirleyin.
4. Kurulumu tamamlayın.

> [!WARNING]
> Firebase Storage kullanımı için projenin **Blaze (Kullandıkça Öde)** planında olması gerekebilir. Geliştirme aşamasındaki düşük boyutlu test kullanımları için fatura limitleri (ücretsiz kota) mevcuttur; beklenmeyen harcamaları önlemek için Google Cloud Console üzerinden bütçe uyarıları ayarlayabilirsiniz.

---

## 8. Güvenlik Kurallarını Dağıtma (Deploy)

SmartClothes reposunda önceden tanımlanmış başlangıç güvenlik kuralları mevcuttur:

| Dosya | Açıklama |
|---|---|
| `firestore.rules` | Firestore veri tabanı güvenlik kuralları |
| `storage.rules` | Firebase Storage dosya erişim güvenlik kuralları |
| `firebase.json` | Firebase CLI yapılandırma dosyası |

Mevcut kurallar istemci tarafındaki tüm okuma ve yazma işlemlerini varsayılan olarak **reddedecek (`allow read, write: if false;`)** şekilde ayarlanmıştır. Kullanıcı kimlik doğrulama sistemi (Commit #05) ile kullanıcılar doğrulanmış olsa dahi, gardırop CRUD işlemleri (Commit #06) tamamlanana kadar veritabanı kuralları sıkı güvenlik amacıyla kapalı kalır.

Kuralları Firebase'e göndermek için terminalden:

```bash
firebase deploy --only firestore:rules,storage
```

---

## 9. Yerel Geliştirme (Local Development)

- **Firebase Olmadan Çalışma:**
  Firebase henüz yapılandırılmamışsa, `FirebaseService.initialize()` fonksiyonu hata fırlatmaz. Konsola şu uyarıyı yazarak uygulamayı demo modunda başlatır:
  ```text
  ⚠️ [SmartClothes] Firebase yapılandırması mevcut değil — Firebase başlatma işlemi kontrollü şekilde atlandı.
  ```
- **Firebase Bağlantısı Yapıldığında:**
  `flutterfire configure` çalıştırıldıktan sonra uygulama açılışında konsolda şu mesaj görülür:
  ```text
  ✅ [SmartClothes] Firebase başarıyla başlatıldı.
  ```

---

## 10. GitHub Actions ve CI Yapılandırması

SmartClothes sürekli entegrasyon (CI) boru hattı (`.github/workflows/ci.yml`):
- `flutter analyze --fatal-infos`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --release --no-codesign`

adımlarını çalıştırır.

CI ortamında gerçek bir Firebase projesi veya kimlik bilgisi **gerekmez**. Uygulama mimarisi eksik yapılandırmayı kontrollü şekilde atladığı için testler ve derlemeler Firebase bağımlılığı olmadan başarıyla tamamlanır. Gizli anahtarlar asla Git reposuna eklenmez.

---

## 11. Firebase Bağlantısını Doğrulama

Firebase kurulumunu doğrulamak için:

1. Uygulamayı emülatörde veya gerçek cihazda başlatın:
   ```bash
   flutter run
   ```
2. Hata ayıklama (debug) konsolunda:
   ```text
   ✅ [SmartClothes] Firebase başarıyla başlatıldı.
   ```
   ifadesinin yer aldığını kontrol edin.
3. `FirebaseService.isInitialized` değerinin `true` döndüğünü teyit edin.
