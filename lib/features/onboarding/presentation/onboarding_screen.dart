import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';

/// Two-step first-run flow. A future commit will add the 40-outfit catalog.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.onSubmit,
    this.initialPreferences,
    this.isEditing = false,
  });

  final Future<void> Function(UserPreferences preferences) onSubmit;
  final UserPreferences? initialPreferences;
  final bool isEditing;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Set<ClothingStyle> _selectedStyles = {};
  ShoppingBudget? _selectedBudget;
  int _step = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedStyles.addAll(widget.initialPreferences?.styles ?? {});
    _selectedBudget = widget.initialPreferences?.budget;
  }

  void _next() {
    if (_selectedStyles.isEmpty) {
      _showMessage('Devam etmek için en az bir tarz seç.');
      return;
    }
    setState(() => _step = 1);
  }

  Future<void> _save({bool skip = false}) async {
    if (_isSaving) return;
    if (!skip && _selectedBudget == null) {
      _showMessage('Lütfen bir bütçe aralığı seç.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      await widget.onSubmit(
        skip
            ? const UserPreferences(isComplete: true)
            : UserPreferences(
                styles: Set<ClothingStyle>.of(_selectedStyles),
                budget: _selectedBudget,
                isComplete: true,
              ),
      );
    } catch (_) {
      if (mounted) _showMessage('Tercihler kaydedilemedi. Lütfen tekrar dene.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  IconData _styleIcon(ClothingStyle style) => switch (style) {
        ClothingStyle.minimal => Icons.checkroom_outlined,
        ClothingStyle.classic => Icons.work_outline_rounded,
        ClothingStyle.streetwear => Icons.skateboarding_outlined,
        ClothingStyle.casual => Icons.weekend_outlined,
        ClothingStyle.sporty => Icons.directions_run_outlined,
        ClothingStyle.elegant => Icons.auto_awesome_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Tercihleri Düzenle' : 'Seni Tanıyalım'),
        automaticallyImplyLeading: widget.isEditing,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: (_step + 1) / 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ADIM ${_step + 1} / 2',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _step == 0 ? 'Tarzın nasıl?' : 'Bütçen nasıl?',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _step == 0
                          ? 'Sevdiğin stilleri seç. Birden fazla tercih yapabilirsin.'
                          : 'Alışveriş önerilerini bütçene göre şekillendirelim.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (_step == 0) _buildStyles(colors) else _buildBudgets(colors),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      widget.isEditing
                          ? 'Değişiklikler yalnızca bu cihazda saklanır.'
                          : 'Tercihlerini dilediğin zaman Profil ekranından değiştirebilirsin.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (_step == 1)
                    TextButton(
                      onPressed: _isSaving ? null : () => setState(() => _step = 0),
                      child: const Text('Geri'),
                    )
                  else if (widget.isEditing)
                    TextButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      child: const Text('Vazgeç'),
                    )
                  else
                    TextButton(
                      onPressed: _isSaving ? null : () => _save(skip: true),
                      child: const Text('Şimdilik atla'),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSaving
                          ? null
                          : _step == 0
                              ? _next
                              : () => _save(),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_step == 0 ? 'İleri' : 'Tercihleri Kaydet'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyles(ColorScheme colors) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: ClothingStyle.values.map((style) {
        final isSelected = _selectedStyles.contains(style);
        return FilterChip(
          selected: isSelected,
          avatar: Icon(_styleIcon(style), size: 20, color: colors.primary),
          label: Text(style.label),
          tooltip: style.description,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedStyles.add(style);
              } else {
                _selectedStyles.remove(style);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildBudgets(ColorScheme colors) {
    return Column(
      children: ShoppingBudget.values.map((budget) {
        final isSelected = _selectedBudget == budget;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Card(
            color: isSelected ? colors.primaryContainer : colors.surface,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              key: ValueKey('budget-${budget.name}'),
              onTap: () => setState(() => _selectedBudget = budget),
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: colors.primary,
              ),
              title: Text(budget.label),
              subtitle: Text(budget.description),
              trailing: isSelected ? const Icon(Icons.check_rounded) : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
