import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/core/config/firebase_config.dart';
import 'package:smartclothes/core/services/firebase/firebase_service.dart';
import 'package:smartclothes/core/services/firebase/firestore_service.dart';
import 'package:smartclothes/core/services/firebase/storage_service.dart';

void main() {
  group('Firebase Infrastructure', () {
    test('FirebaseConfig isConfigured is false in unconfigured state', () {
      expect(FirebaseConfig.isConfigured, isFalse);
      expect(FirebaseConfig.currentPlatformOptions, isNull);
    });

    test('FirebaseService.isInitialized is false before initialization', () {
      expect(FirebaseService.isInitialized, isFalse);
    });

    test(
      'FirebaseService.initialize() safely skips initialization when unconfigured',
      () async {
        // Must complete normally without throwing or crashing
        await expectLater(FirebaseService.initialize(), completes);
        expect(FirebaseService.isInitialized, isFalse);
      },
    );

    test('FirestoreService.instance returns null when Firebase is uninitialized', () {
      expect(FirestoreService.instance, isNull);
    });

    test('StorageService.instance returns null when Firebase is uninitialized', () {
      expect(StorageService.instance, isNull);
    });
  });
}
