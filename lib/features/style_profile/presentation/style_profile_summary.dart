import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/core/widgets/smart_section_header.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/style_profile/models/style_profile.dart';

/// Read-only profile summary. Rebuilt from current favorite outfit ids.
class StyleProfileSummary extends StatelessWidget {
  const StyleProfileSummary({
    super.key,
    required this.profile,
    required this.onChooseOutfits,
  });

  final StyleProfile profile;
  final VoidCallback onChooseOutfits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      key: const ValueKey('style-profile-section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SmartSectionHeader(
          title: 'Stil Analizim',
          subtitle: 'Beğendiğin referans kombinlerden hesaplanır',
        ),
        SmartCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: profile.hasEnoughData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.analyzedOutfitCount} kombin incelendi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Baskın tarzın: ${profile.dominantStyle!.label}',
                        key: const ValueKey('dominant-style-label'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: profile.styles
                          .map((entry) => Chip(
                                label: Text(
                                  '${entry.style.label} %${(entry.share * 100).round()}',
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _TraitGroup(
                      title: 'Öne çıkan renkler',
                      traits: profile.colors.take(4).toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _TraitGroup(
                      title: 'Tercih ettiğin kalıplar',
                      traits: profile.fits.take(3).toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _TraitGroup(
                      title: 'Kullanım alanları',
                      traits: profile.occasions.take(3).toList(),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stil analizini görmek için en az 5 kombin beğen.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${profile.analyzedOutfitCount} / ${StyleProfile.minimumOutfits} kombin seçildi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: onChooseOutfits,
                      icon: const Icon(Icons.favorite_border_rounded),
                      label: const Text('Kombinleri İncele'),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _TraitGroup extends StatelessWidget {
  const _TraitGroup({required this.title, required this.traits});

  final String title;
  final List<StyleTrait> traits;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        if (traits.isEmpty)
          const Text('Henüz veri yok')
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: traits
                .map((entry) => Chip(
                      label: Text('${entry.label} · ${entry.count}'),
                    ))
                .toList(),
          ),
      ],
    );
  }
}
