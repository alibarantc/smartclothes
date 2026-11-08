import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/core/services/firebase/firebase_service.dart';
import 'package:smartclothes/features/auth/models/auth_result.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';

void main() {
  setUp(() {
    FirebaseService.resetForTesting();
    AuthService.instance = AuthService();
  });

  group('AuthResult Model Tests', () {
    test('AuthResult.success creates valid success result', () {
      final result = AuthResult.success();
      expect(result.isSuccess, isTrue);
      expect(result.user, isNull);
      expect(result.errorMessage, isNull);
      expect(result.isConfigurationMissing, isFalse);
    });

    test('AuthResult.failure creates valid failure result with Turkish error', () {
      const message = 'E-posta veya şifre hatalı.';
      final result = AuthResult.failure(message);
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, equals(message));
      expect(result.isConfigurationMissing, isFalse);
    });

    test('AuthResult.configurationMissing indicates missing Firebase setup', () {
      final result = AuthResult.configurationMissing();
      expect(result.isSuccess, isFalse);
      expect(result.isConfigurationMissing, isTrue);
      expect(result.errorMessage, contains('Firebase projesi henüz yapılandırılmadı'));
    });
  });

  group('AuthService Unconfigured Tests', () {
    test('isFirebaseAvailable returns false when Firebase is uninitialized', () {
      final auth = AuthService.instance;
      expect(auth.isFirebaseAvailable, isFalse);
      expect(auth.currentUser, isNull);
    });

    test('signInWithEmailAndPassword returns configurationMissing safely', () async {
      final auth = AuthService.instance;
      final result = await auth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );
      expect(result.isSuccess, isFalse);
      expect(result.isConfigurationMissing, isTrue);
    });

    test('registerWithEmailAndPassword returns configurationMissing safely', () async {
      final auth = AuthService.instance;
      final result = await auth.registerWithEmailAndPassword(
        name: 'Deniz Yılmaz',
        email: 'test@example.com',
        password: 'password123',
      );
      expect(result.isSuccess, isFalse);
      expect(result.isConfigurationMissing, isTrue);
    });

    test('sendPasswordResetEmail returns configurationMissing safely', () async {
      final auth = AuthService.instance;
      final result = await auth.sendPasswordResetEmail(
        email: 'test@example.com',
      );
      expect(result.isSuccess, isFalse);
      expect(result.isConfigurationMissing, isTrue);
    });

    test('enterDemoMode and signOut manage demo session state', () async {
      final auth = AuthService.instance;
      expect(auth.isDemoMode.value, isFalse);

      auth.enterDemoMode();
      expect(auth.isDemoMode.value, isTrue);

      await auth.signOut();
      expect(auth.isDemoMode.value, isFalse);
    });

    test('authStateChanges emits null when unconfigured', () async {
      final auth = AuthService.instance;
      final user = await auth.authStateChanges.first;
      expect(user, isNull);
    });
  });
}
