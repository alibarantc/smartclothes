import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';

/// A reusable loading indicator component matching the SmartClothes design language.
class SmartLoadingIndicator extends StatelessWidget {
  const SmartLoadingIndicator({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 2.5,
    this.color,
    this.message,
  });

  /// Size (diameter) of the spinner.
  final double size;

  /// Thickness of the spinner line.
  final double strokeWidth;

  /// Explicit color override. Defaults to [ColorScheme.primary].
  final Color? color;

  /// Optional message displayed beneath the spinner.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    final spinner = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        strokeCap: StrokeCap.round,
      ),
    );

    if (message == null || message!.isEmpty) {
      return spinner;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        spinner,
        const SizedBox(height: AppSpacing.sm),
        Text(
          message!,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
