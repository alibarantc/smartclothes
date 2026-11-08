import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smartclothes/core/services/firebase/firebase_service.dart';
import 'package:smartclothes/features/auth/models/auth_result.dart';

/// Service managing user authentication operations for SmartClothes.
///
/// Encapsulates [FirebaseAuth] interaction and safely falls back to offline / demo
/// behavior when a real Firebase project is not yet configured.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth}) : _customAuth = firebaseAuth;

  static AuthService? _instance;

  /// Global singleton instance.
  static AuthService get instance => _instance ??= AuthService();

  /// Allows replacing the singleton instance in widget/unit tests.
  @visibleForTesting
  static set instance(AuthService service) {
    _instance = service;
  }

  final FirebaseAuth? _customAuth;
  FirebaseAuth? _resolvedAuth;

  FirebaseAuth? get _auth {
    if (_customAuth != null) {
      return _customAuth;
    }
    if (!FirebaseService.isInitialized) {
      return null;
    }
    _resolvedAuth ??= FirebaseAuth.instance;
    return _resolvedAuth;
  }

  /// Whether Firebase is initialized and an auth instance is available.
  bool get isFirebaseAvailable =>
      _customAuth != null || (FirebaseService.isInitialized && _auth != null);

  /// Tracks whether the user opted to explore the app in Guest/Demo mode.
  final ValueNotifier<bool> isDemoMode = ValueNotifier<bool>(false);

  /// Current authenticated [User], or null if not signed in / unconfigured.
  User? get currentUser {
    if (!isFirebaseAvailable) return null;
    return _auth?.currentUser;
  }

  /// Broadcasts authentication state changes.
  ///
  /// Emits `null` if Firebase is not configured or the user is signed out.
  Stream<User?> get authStateChanges {
    if (!isFirebaseAvailable) {
      return Stream<User?>.value(null);
    }
    return _auth!.authStateChanges();
  }

  /// Activates Demo Mode for local testing and exploration.
  void enterDemoMode() {
    isDemoMode.value = true;
  }

  /// Authenticates using email and password.
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!isFirebaseAvailable) {
      return AuthResult.configurationMissing();
    }

    try {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      isDemoMode.value = false;
      return AuthResult.success(credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseErrorToTurkish(e.code, e.message));
    } catch (e) {
      return AuthResult.failure('Giriş yapılırken beklenmeyen bir hata oluştu.');
    }
  }

  /// Registers a new user with email and password, setting [name] as displayName.
  Future<AuthResult> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!isFirebaseAvailable) {
      return AuthResult.configurationMissing();
    }

    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null && name.trim().isNotEmpty) {
        await user.updateDisplayName(name.trim());
        await user.reload();
      }
      isDemoMode.value = false;
      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseErrorToTurkish(e.code, e.message));
    } catch (e) {
      return AuthResult.failure('Kayıt oluşturulurken beklenmeyen bir hata oluştu.');
    }
  }

  /// Requests a password reset email for [email].
  Future<AuthResult> sendPasswordResetEmail({
    required String email,
  }) async {
    if (!isFirebaseAvailable) {
      return AuthResult.configurationMissing();
    }

    try {
      await _auth!.sendPasswordResetEmail(email: email.trim());
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseErrorToTurkish(e.code, e.message));
    } catch (e) {
      return AuthResult.failure('Şifre sıfırlama bağlantısı gönderilemedi.');
    }
  }

  /// Signs out the user and exits demo mode.
  Future<void> signOut() async {
    isDemoMode.value = false;
    if (isFirebaseAvailable) {
      await _auth?.signOut();
    }
  }

  /// Maps standard Firebase error codes to descriptive Turkish messages.
  String _mapFirebaseErrorToTurkish(String code, String? defaultMessage) {
    switch (code) {
      case 'invalid-email':
        return 'Geçersiz bir e-posta adresi girdiniz.';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmıştır.';
      case 'user-not-found':
        return 'Bu e-posta adresiyle kayıtlı bir hesap bulunamadı.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda.';
      case 'operation-not-allowed':
        return 'E-posta/şifre ile giriş Firebase konsolunda henüz etkinleştirilmemiş.';
      case 'weak-password':
        return 'Şifre çok zayıf. Lütfen en az 6 karakterli daha güçlü bir şifre belirleyin.';
      case 'network-request-failed':
        return 'Ağ bağlantısı başarısız. Lütfen internet bağlantınızı kontrol edin.';
      case 'too-many-requests':
        return 'Çok fazla başarısız deneme yapıldı. Lütfen biraz bekleyin ve tekrar deneyin.';
      default:
        return defaultMessage ?? 'Bir kimlik doğrulama hatası oluştu ($code).';
    }
  }
}
