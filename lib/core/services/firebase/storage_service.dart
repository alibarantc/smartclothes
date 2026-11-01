import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartclothes/core/services/firebase/firebase_service.dart';

/// Provides access to Firebase Storage for the SmartClothes app.
///
/// This is a thin service layer that keeps Storage access separated from the
/// presentation layer. Clothing photo upload and retrieval will be implemented
/// here in a future commit once Firebase Authentication is in place.
///
/// Usage is gated on [FirebaseService.isInitialized]. Calling any method when
/// Firebase has not been initialized will return null gracefully.
class StorageService {
  StorageService._();

  static FirebaseStorage? _instance;

  /// Returns the [FirebaseStorage] instance.
  ///
  /// Returns null if Firebase has not been initialized.
  static FirebaseStorage? get instance {
    if (!FirebaseService.isInitialized) {
      return null;
    }
    _instance ??= FirebaseStorage.instance;
    return _instance;
  }

  // ---------------------------------------------------------------------------
  // Future clothing photo upload/download methods will be added here.
  // Example:
  //   static Future<String> uploadClothingPhoto(String userId, File photo) async { … }
  //   static Future<String?> getDownloadUrl(String path) async { … }
  // ---------------------------------------------------------------------------
}

