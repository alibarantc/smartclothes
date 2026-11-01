import 'package:firebase_core/firebase_core.dart';

/// Central configuration manager for Firebase services.
///
/// This class decouples Firebase option resolution from the rest of the application.
/// In this stage (Commit #04), no real Firebase project credentials are configured,
/// ensuring that no fake IDs or secrets are checked into source control.
///
/// When a Firebase project is connected via `flutterfire configure`, the generated
/// configuration options can be returned by [currentPlatformOptions].
class FirebaseConfig {
  FirebaseConfig._();

  /// Returns [FirebaseOptions] for the current platform if configured.
  ///
  /// Currently returns `null` because no real Firebase project has been linked yet.
  /// This allows [FirebaseService.initialize] to detect the absence of configuration
  /// and gracefully skip the initialization step without throwing exceptions.
  static FirebaseOptions? get currentPlatformOptions {
    return null;
  }

  /// Whether a valid Firebase configuration is present.
  static bool get isConfigured => currentPlatformOptions != null;
}
