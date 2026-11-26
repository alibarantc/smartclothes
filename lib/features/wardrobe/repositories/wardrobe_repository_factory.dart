import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/wardrobe/repositories/firestore_wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/repositories/local_wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';

/// Choose an explicit persistence backend. Guest metadata stays on-device;
/// authenticated users use the Firestore repository.
class WardrobeRepositoryFactory {
  const WardrobeRepositoryFactory._();

  static WardrobeRepository forCurrentSession({AuthService? authService}) {
    final auth = authService ?? AuthService.instance;
    if (auth.isDemoMode.value) return const LocalWardrobeRepository();
    if (auth.currentUser != null && auth.isFirebaseAvailable) {
      return const FirestoreWardrobeRepository();
    }
    throw StateError('Gardırop için giriş yap veya demo modunu aç.');
  }
}
