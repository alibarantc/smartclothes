import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';

/// Reusable information card explaining that cloud Firebase authentication
/// is awaiting project configuration and offering offline exploration.
class AuthUnconfiguredCard extends StatelessWidget {
  const AuthUnconfiguredCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SmartCard(
      backgroundColor: colorScheme.secondaryContainer.withOpacity(0.5),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.primary,
            size: 24.0,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Firebase Yapılandırması Bekleniyor',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Bulut tabanlı hesap özellikleri henüz bağlanmadı. Uygulamayı incelemek için "Demo Olarak Devam Et" seçeneğini kullanabilirsiniz.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
