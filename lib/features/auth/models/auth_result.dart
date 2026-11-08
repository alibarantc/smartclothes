import 'package:firebase_auth/firebase_auth.dart';

/// Represents the structured outcome of an authentication attempt.
class AuthResult {
  const AuthResult({
    required this.isSuccess,
    this.user,
    this.errorMessage,
    this.isConfigurationMissing = false,
  });

  /// Successful authentication result with an optional [User].
  factory AuthResult.success([User? user]) => AuthResult(
        isSuccess: true,
        user: user,
      );

  /// Failed authentication result with an informative [message].
  factory AuthResult.failure(String message) => AuthResult(
        isSuccess: false,
        errorMessage: message,
      );

  /// Result when Firebase configuration has not yet been linked to the app.
  factory AuthResult.configurationMissing([String? message]) => AuthResult(
        isSuccess: false,
        isConfigurationMissing: true,
        errorMessage: message ??
            'Firebase projesi henüz yapılandırılmadı. Lütfen docs/firebase-setup.md kılavuzunu inceleyin veya Demo Modu ile devam edin.',
      );

  /// Whether the operation succeeded.
  final bool isSuccess;

  /// The authenticated Firebase user, if available.
  final User? user;

  /// User-friendly error message in Turkish.
  final String? errorMessage;

  /// True if the operation failed specifically because Firebase is unconfigured.
  final bool isConfigurationMissing;
}
