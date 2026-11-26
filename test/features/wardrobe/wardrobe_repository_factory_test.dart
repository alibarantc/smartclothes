import 'package:flutter_test/flutter_test.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/wardrobe/repositories/local_wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository_factory.dart';

void main() {
  test('demo selects local persistence, without requiring Firebase', () {
    final auth = AuthService()..enterDemoMode();
    final repository =
        WardrobeRepositoryFactory.forCurrentSession(authService: auth);
    expect(repository, isA<LocalWardrobeRepository>());
  });

  test('unconfigured unauthenticated session cannot claim cloud persistence', () {
    expect(
      () => WardrobeRepositoryFactory.forCurrentSession(
        authService: AuthService(),
      ),
      throwsStateError,
    );
  });
}
