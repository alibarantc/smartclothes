import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:smartclothes/core/config/firebase_config.dart';

/// Handles Firebase lifecycle and initialization for SmartClothes.
///
/// Firebase initialization is attempted once during app startup in [main].
/// If no Firebase project is configured (which is the case until a developer
/// runs `flutterfire configure`), the absence of configuration is reported
/// clearly in the console and initialization is safely skipped.
class FirebaseService {
  FirebaseService._();

  static bool _initialized = false;

  /// Whether Firebase has been successfully initialized.
  static bool get isInitialized => _initialized;

  /// Attempts to initialize Firebase.
  ///
  /// If Firebase configuration is not present, reports this clearly and skips
  /// initialization without throwing or crashing the application.
  static Future<void> initialize() async {
    final options = FirebaseConfig.currentPlatformOptions;

    if (!FirebaseConfig.isConfigured && options == null) {
      _initialized = false;
      debugPrint(
        '⚠️ [SmartClothes] Firebase yapılandırması mevcut değil — '
        'Firebase başlatma işlemi kontrollü şekilde atlandı.\n'
        '   Uygulama demo modunda ve çevrimdışı çalışmaya devam ediyor.\n'
        '   Firebase kurulum adımları için docs/firebase-setup.md belgesini inceleyin.',
      );
      return;
    }

    try {
      await Firebase.initializeApp(options: options);
      _initialized = true;
      debugPrint('✅ [SmartClothes] Firebase başarıyla başlatıldı.');
    } catch (e) {
      _initialized = false;
      debugPrint('❌ [SmartClothes] Firebase başlatılırken hata oluştu: $e');
    }
  }
}
