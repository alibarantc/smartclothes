import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/core/widgets/smart_loading_indicator.dart';

/// Style variants available for [SmartButton].
enum SmartButtonVariant {
  primary,
  secondary,
  outlined,
  text,
}

/// A modern, consistent button component supporting loading states, icons,
/// and multiple style variants.
class SmartButton extends StatelessWidget {
  const SmartButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = SmartButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
    this.height = 50.0,
    this.padding,
  });

  /// Text displayed inside the button.
  final String text;

  /// Callback when pressed. If null or [isDisabled] or [isLoading], button is disabled.
  final VoidCallback? onPressed;

  /// Visual style variant.
  final SmartButtonVariant variant;

  /// Whether the button is in an active loading state.
  final bool isLoading;

  /// Whether the button is explicitly disabled.
  final bool isDisabled;

  /// Optional icon placed before the text.
  final IconData? icon;

  /// Whether the button should stretch to fill available width.
  final bool isFullWidth;

  /// Target height for the button.
  final double height;

  /// Custom padding inside the button.
  final EdgeInsetsGeometry? padding;

  bool get _canPress => !isDisabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = _canPress ? onPressed : null;

    final content = _buildContent(context, colorScheme);

    final Widget button = switch (variant) {
      SmartButtonVariant.primary => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
          ),
          child: content,
        ),
      SmartButtonVariant.secondary => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.secondaryContainer,
            foregroundColor: colorScheme.onSecondaryContainer,
            elevation: 0,
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
          ),
          child: content,
        ),
      SmartButtonVariant.outlined => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
          ),
          child: content,
        ),
      SmartButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
          ),
          child: content,
        ),
    };

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: button,
      );
    }

    return SizedBox(
      height: height,
      child: button,
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme) {
    if (isLoading) {
      final spinnerColor = switch (variant) {
        SmartButtonVariant.primary => colorScheme.onPrimary,
        SmartButtonVariant.secondary => colorScheme.onSecondaryContainer,
        SmartButtonVariant.outlined => colorScheme.primary,
        SmartButtonVariant.text => colorScheme.primary,
      };

      return SmartLoadingIndicator(
        size: 20.0,
        strokeWidth: 2.2,
        color: spinnerColor,
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20.0),
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
