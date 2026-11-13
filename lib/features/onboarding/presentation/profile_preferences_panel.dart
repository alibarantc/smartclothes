import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/core/widgets/smart_section_header.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/onboarding/presentation/onboarding_screen.dart';
import 'package:smartclothes/features/onboarding/services/preferences_store.dart';

/// Displays saved preferences and reopens the same flow for editing.
class ProfilePreferencesPanel extends StatefulWidget {
  const ProfilePreferencesPanel({super.key});

  @override
  State<ProfilePreferencesPanel> createState() => _ProfilePreferencesPanelState();
}

class _ProfilePreferencesPanelState extends State<ProfilePreferencesPanel> {
  final PreferencesStore _store = const PreferencesStore();
  late Future<UserPreferences?> _currentPreferences;

  String get _identity => AuthService.instance.currentUser?.uid ?? 'demo';

  @override
  void initState() {
    super.initState();
    _currentPreferences = _store.load(_identity);
  }

  Future<void> _editPreferences() async {
    UserPreferences? initial;
    try {
      initial = await _currentPreferences;
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tercihler yüklenemedi. Tekrar dene.')),
      );
      return;
    }
    if (!mounted) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (editorContext) => OnboardingScreen(
          initialPreferences: initial,
          isEditing: true,
          onSubmit: (preferences) async {
            final saved = await _store.save(_identity, preferences);
            if (!saved) throw StateError('Preferences could not be persisted');
            if (editorContext.mounted) Navigator.of(editorContext).pop();
          },
        ),
      ),
    );

    if (mounted) {
      setState(() => _currentPreferences = _store.load(_identity));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<UserPreferences?>(
      future: _currentPreferences,
      builder: (context, snapshot) {
        final preferences = snapshot.data;
        final styles = preferences == null || preferences.styles.isEmpty
            ? 'Henüz bir tarz seçilmedi'
            : preferences.styles.map((style) => style.label).join(', ');
        final budget = preferences?.budget?.label ?? 'Bütçe belirlenmedi';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SmartSectionHeader(
              title: 'Stil Tercihleri',
              subtitle: 'Kişiselleştirilmiş kombin önerileri için',
            ),
            SmartCard(
              onTap: snapshot.connectionState == ConnectionState.waiting
                  ? null
                  : _editPreferences,
              child: Row(
                children: [
                  Icon(Icons.style_outlined, color: colorScheme.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(styles)),
                  const Icon(Icons.edit_outlined),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SmartSectionHeader(
              title: 'Bütçe Tercihleri',
              subtitle: 'Alışveriş önerilerinin bütçe aralığı',
            ),
            SmartCard(
              onTap: snapshot.connectionState == ConnectionState.waiting
                  ? null
                  : _editPreferences,
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      color: colorScheme.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(budget)),
                  const Icon(Icons.edit_outlined),
                ],
              ),
            ),
            if (snapshot.hasError) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => setState(() {
                  _currentPreferences = _store.load(_identity);
                }),
                child: const Text('Tercihleri yeniden yükle'),
              ),
            ],
          ],
        );
      },
    );
  }
}
