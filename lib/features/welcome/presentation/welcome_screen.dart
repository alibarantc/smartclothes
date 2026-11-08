import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_button.dart';
import 'package:smartclothes/core/widgets/smart_card.dart';
import 'package:smartclothes/features/auth/presentation/login_screen.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';

/// Welcome screen introducing SmartClothes and serving as the visual entry point.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    this.onGetStarted,
  });

  /// Optional callback invoked when the user taps the get started button.
  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.lg),

                      // Wardrobe-themed clean icon container
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.checkroom_rounded,
                          size: 64,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // App Name
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Slogan
                      Text(
                        AppConstants.appSlogan,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Description
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 340),
                        child: Text(
                          AppConstants.appDescription,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Highlight Card (Clean, minimalist feature glance)
                      SmartCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        backgroundColor: colorScheme.surface,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: Text(
                                'Kişiselleştirilmiş akıllı stil asistanı',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Get Started Action Button
                      SmartButton(
                        text: 'Başla',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: onGetStarted ??
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Demo Mode Button
                      SmartButton(
                        text: 'Demo Olarak Devam Et',
                        icon: Icons.explore_outlined,
                        variant: SmartButtonVariant.outlined,
                        onPressed: () {
                          AuthService.instance.enterDemoMode();
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
