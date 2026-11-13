import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';

/// Stores only non-sensitive style preferences on this device.
///
/// A signed-in user's Firebase UID and the demo identity get separate keys.
/// This is intentionally local until account syncing is implemented.
class PreferencesStore {
  const PreferencesStore();

  String storageKey(String identity) =>
      'smartclothes.preferences.v1.${Uri.encodeComponent(identity)}';

  Future<UserPreferences?> load(String identity) async {
    final storage = await SharedPreferences.getInstance();
    final raw = storage.getString(storageKey(identity));
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return UserPreferences.fromJson(decoded);
    } on FormatException {
      return null;
    }
  }

  Future<bool> save(String identity, UserPreferences preferences) async {
    final storage = await SharedPreferences.getInstance();
    return storage.setString(storageKey(identity), jsonEncode(preferences.toJson()));
  }
}
