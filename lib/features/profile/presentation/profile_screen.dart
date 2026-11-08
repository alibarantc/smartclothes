import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_button.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/core/widgets/smart_section_header.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';

/// Profile screen presenting guest user scaffold, upcoming preference
/// categories (style, budget), and application settings placeholders.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authService = AuthService.instance;

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
              // Profile Header
              ValueListenableBuilder<bool>(
                valueListenable: authService.isDemoMode,
                builder: (context, isDemo, _) {
                  final user = authService.currentUser;
                  final String profileTitle;
                  final String profileSubtitle;
                  final String badgeLabel;

                  if (user != null) {
                    profileTitle = (user.displayName != null && user.displayName!.trim().isNotEmpty)
                        ? user.displayName!
                        : (user.email ?? 'SmartClothes Kullanıcısı');
                    profileSubtitle = user.email ?? 'Firebase Oturumu Aktif';
                    badgeLabel = 'Doğrulandı';
                  } else if (isDemo) {
                    profileTitle = 'Misafir / Demo Modu';
                    profileSubtitle = 'Demo modundasınız. Bulut senkronizasyonu devre dışı.';
                    badgeLabel = 'Demo';
                  } else {
                    profileTitle = 'Misafir Kullanıcı';
                    profileSubtitle = 'Hesap oluşturma ve senkronizasyon yakında.';
                    badgeLabel = 'Çevrimdışı';
                  }

                  return SmartCard(
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
                            user != null ? Icons.person_rounded : Icons.person_outline_rounded,
                            size: 36,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      profileTitle,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
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
                                      badgeLabel,
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                profileSubtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
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

              const SizedBox(height: AppSpacing.lg),

              ValueListenableBuilder<bool>(
                valueListenable: authService.isDemoMode,
                builder: (context, isDemo, _) {
                  return SmartButton(
                    text: isDemo ? 'Demo Modundan Çık' : 'Çıkış Yap',
                    icon: Icons.logout_rounded,
                    variant: SmartButtonVariant.outlined,
                    onPressed: () async {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      await authService.signOut();
                    },
                  );
                },
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
