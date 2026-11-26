import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartclothes/core/navigation/main_navigation_screen.dart';
import 'package:smartclothes/core/widgets/smart_loading_indicator.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/onboarding/presentation/onboarding_screen.dart';
import 'package:smartclothes/features/onboarding/services/preferences_store.dart';
import 'package:smartclothes/features/welcome/presentation/welcome_screen.dart';
import 'package:smartclothes/features/style_catalog/presentation/reference_outfit_gallery_screen.dart';

/// Routes signed-in or demo users through onboarding only on their first visit.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;

    return ValueListenableBuilder<bool>(
      valueListenable: authService.isDemoMode,
      builder: (context, isDemo, _) {
        if (isDemo) {
          return const _OnboardingEntry(
            key: ValueKey('onboarding-demo'),
            identity: 'demo',
          );
        }

        if (!authService.isFirebaseAvailable) {
          return const WelcomeScreen();
        }

        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: SmartLoadingIndicator(
                    size: 40.0,
                    message: 'Oturum durumu kontrol ediliyor...',
                  ),
                ),
              );
            }

            final user = snapshot.data;
            if (user != null) {
              return _OnboardingEntry(
                key: ValueKey('onboarding-${user.uid}'),
                identity: user.uid,
              );
            }

            return const WelcomeScreen();
          },
        );
      },
    );
  }
}

class _OnboardingEntry extends StatefulWidget {
  const _OnboardingEntry({super.key, required this.identity});

  final String identity;

  @override
  State<_OnboardingEntry> createState() => _OnboardingEntryState();
}

class _OnboardingEntryState extends State<_OnboardingEntry> {
  final PreferencesStore _store = const PreferencesStore();
  late Future<UserPreferences?> _savedPreferences;
  bool _completedNow = false;

  @override
  void initState() {
    super.initState();
    _savedPreferences = _store.load(widget.identity);
  }

  Future<void> _finish(UserPreferences preferences) async {
    final requiresGallery = preferences.styles.isNotEmpty &&
        preferences.budget != null &&
        preferences.favoriteOutfitIds.length < 5;
    final staged = requiresGallery
        ? UserPreferences(
            styles: preferences.styles,
            budget: preferences.budget,
            favoriteOutfitIds: preferences.favoriteOutfitIds,
            isComplete: false,
          )
        : preferences;
    final saved = await _store.save(widget.identity, staged);
    if (!saved) throw StateError('Preferences could not be persisted');
    if (mounted) {
      setState(() {
        if (requiresGallery) {
          _savedPreferences = Future<UserPreferences?>.value(staged);
        } else {
          _completedNow = true;
        }
      });
    }
  }

  Future<void> _finishGallery(Set<String> selectedIds) async {
    final previous = await _store.load(widget.identity);
    if (previous == null) throw StateError('Preferences are missing');
    final completed = UserPreferences(
      styles: previous.styles,
      budget: previous.budget,
      favoriteOutfitIds: selectedIds,
      isComplete: true,
    );
    final saved = await _store.save(widget.identity, completed);
    if (!saved) throw StateError('Gallery choices could not be persisted');
    if (mounted) setState(() => _completedNow = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_completedNow) return const MainNavigationScreen();

    return FutureBuilder<UserPreferences?>(
      future: _savedPreferences,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: TextButton.icon(
                onPressed: () => setState(() {
                  _savedPreferences = _store.load(widget.identity);
                }),
                icon: const Icon(Icons.refresh),
                label: const Text('Tercihler yüklenemedi, tekrar dene'),
              ),
            ),
          );
        }
        if (snapshot.data?.isComplete == true) {
          return const MainNavigationScreen();
        }
        final current = snapshot.data;
        if (current != null &&
            current.styles.isNotEmpty &&
            current.budget != null &&
            !current.isComplete) {
          return ReferenceOutfitGalleryScreen(
            key: const ValueKey('onboarding-gallery'),
            initialSelection: current.favoriteOutfitIds,
            onSave: _finishGallery,
          );
        }
        return OnboardingScreen(
          initialPreferences: snapshot.data,
          onSubmit: _finish,
        );
      },
    );
  }
}
