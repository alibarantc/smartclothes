import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';

/// A section header with title, optional subtitle, and an action widget/button.
class SmartSectionHeader extends StatelessWidget {
  const SmartSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.actionText,
    this.onActionPressed,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.sm),
  });

  /// Primary heading text.
  final String title;

  /// Secondary explanatory subtitle.
  final String? subtitle;

  /// Custom action widget placed on the right side.
  final Widget? action;

  /// Shortcut label for a text button action.
  final String? actionText;

  /// Callback when [actionText] is tapped.
  final VoidCallback? onActionPressed;

  /// Padding around the header.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? actionWidget = action;
    if (actionWidget == null && actionText != null) {
      actionWidget = TextButton(
        onPressed: onActionPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(actionText!),
      );
    }

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment:
            subtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actionWidget != null) ...[
            const SizedBox(width: AppSpacing.md),
            actionWidget,
          ],
        ],
      ),
    );
  }
}
