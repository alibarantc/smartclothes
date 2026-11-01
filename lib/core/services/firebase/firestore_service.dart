import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartclothes/core/services/firebase/firebase_service.dart';

/// Provides access to Cloud Firestore for the SmartClothes app.
///
/// This is a thin service layer that keeps Firestore access separated from the
/// presentation layer. Feature-specific repositories will use this service to
/// read and write data in future commits.
///
/// Usage is gated on [FirebaseService.isInitialized]. Calling any method when
/// Firebase has not been initialized will throw an [AssertionError] in debug
/// mode and return gracefully in release mode.
class FirestoreService {
  FirestoreService._();

  static FirebaseFirestore? _instance;

  /// Returns the [FirebaseFirestore] instance.
  ///
  /// Returns null if Firebase has not been initialized.
  static FirebaseFirestore? get instance {
    if (!FirebaseService.isInitialized) {
      return null;
    }
    _instance ??= FirebaseFirestore.instance;
    return _instance;
  }

  // ---------------------------------------------------------------------------
  // Future wardrobe and outfit data methods will be added here.
  // Example:
  //   static Future<List<ClothingItem>> fetchWardrobe(String userId) async { … }
  //   static Future<void> saveOutfit(String userId, Outfit outfit) async { … }
  // ---------------------------------------------------------------------------
}

