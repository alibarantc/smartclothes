import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';

/// A reusable surface card for groupings, list items, and feature containers.
class SmartCard extends StatelessWidget {
  const SmartCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppRadius.roundedLg,
    this.borderWidth = 1.0,
    this.elevation = 0.0,
    this.onTap,
  });

  /// Widget placed inside the card.
  final Widget child;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// External margin.
  final EdgeInsetsGeometry? margin;

  /// Card surface color. Defaults to [ColorScheme.surface].
  final Color? backgroundColor;

  /// Border outline color. Defaults to [ColorScheme.outline].
  final Color? borderColor;

  /// Corner radius. Defaults to [AppRadius.roundedLg].
  final BorderRadius borderRadius;

  /// Border stroke width. Defaults to 1.0.
  final double borderWidth;

  /// Shadow elevation. Defaults to 0.0 (flat Material 3 aesthetic).
  final double elevation;

  /// Optional tap callback. When provided, adds an ink ripple effect.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBgColor = backgroundColor ?? colorScheme.surface;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;

    final borderShape = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: borderWidth > 0
          ? BorderSide(color: effectiveBorderColor, width: borderWidth)
          : BorderSide.none,
    );

    Widget cardBody = Padding(
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      cardBody = InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: cardBody,
      );
    }

    return Container(
      margin: margin,
      child: Material(
        color: effectiveBgColor,
        elevation: elevation,
        shape: borderShape,
        clipBehavior: Clip.antiAlias,
        child: cardBody,
      ),
    );
  }
}
