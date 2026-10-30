import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/core/widgets/smart_section_header.dart';

/// Profile screen presenting guest user scaffold, upcoming preference
/// categories (style, budget), and application settings placeholders.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Guest Profile Header (No fake username or email)
              SmartCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 36,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Misafir Kullanıcı',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Hesap oluşturma ve senkronizasyon yakında.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 1. Stil Tercihleri Bölümü
              const SmartSectionHeader(
                title: 'Stil Tercihleri',
                subtitle: 'Kişiselleştirilmiş öneriler için tarzını belirle',
              ),
              SmartCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    const _ProfilePlaceholderTile(
                      icon: Icons.style_outlined,
                      title: 'Giyim Tarzı',
                      subtitle: 'Minimalist, Klasik, Sokak Modası',
                      badgeText: 'Yakında',
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    const _ProfilePlaceholderTile(
                      icon: Icons.palette_outlined,
                      title: 'Favori Renk Paletleri',
                      subtitle: 'Toprak tonları, Monokrom, Pastel',
                      badgeText: 'Yakında',
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    const _ProfilePlaceholderTile(
                      icon: Icons.straighten_outlined,
                      title: 'Kalıp & Beden Tercihleri',
                      subtitle: 'Oversize, Slim, Regular',
                      badgeText: 'Yakında',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 2. Bütçe Tercihleri Bölümü
              const SmartSectionHeader(
                title: 'Bütçe Tercihleri',
                subtitle: 'Alışveriş ve parça önerileri için bütçe hedefleri',
              ),
              SmartCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    const _ProfilePlaceholderTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Alışveriş Bütçe Aralığı',
                      subtitle: 'Aylık giyim harcama hedefi',
                      badgeText: 'Yakında',
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    const _ProfilePlaceholderTile(
                      icon: Icons.eco_outlined,
                      title: 'Sürdürülebilirlik Odaklılığı',
                      subtitle: 'Mevcut dolabı değerlendirme ve döngüsel moda',
                      badgeText: 'Yakında',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 3. Uygulama Ayarları Bölümü
              const SmartSectionHeader(
                title: 'Uygulama Ayarları',
                subtitle: 'Görünüm ve genel tercihler',
              ),
              SmartCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    const _ProfilePlaceholderTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Tema Tercihi',
                      subtitle: 'Sistem Teması (Açık / Koyu)',
                      badgeText: 'Otomatik',
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    const _ProfilePlaceholderTile(
                      icon: Icons.notifications_outlined,
                      title: 'Bildirimler',
                      subtitle: 'Günlük kombin hatırlatması',
                      badgeText: 'Yakında',
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    const _ProfilePlaceholderTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Uygulama Sürümü',
                      subtitle: 'v0.3.0 (Alpha)',
                      badgeText: 'Güncel',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfilePlaceholderTile extends StatelessWidget {
  const _ProfilePlaceholderTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badgeText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.mdSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppRadius.roundedSm,
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: AppRadius.roundedSm,
            ),
            child: Text(
              badgeText,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
