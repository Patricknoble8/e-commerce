import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The canonical back affordance used by app bars throughout the app.
///
/// Defaults to popping the current route safely. Supply [onPressed] when a
/// screen needs to perform work (for example, confirm unsaved changes) first.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.foregroundColor,
    this.backgroundColor,
  });

  final VoidCallback? onPressed;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor =
        foregroundColor ??
        theme.appBarTheme.foregroundColor ??
        theme.colorScheme.onSurface;
    final circleColor =
        backgroundColor ??
        theme.appBarTheme.backgroundColor ??
        theme.colorScheme.surface;

    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        HapticFeedback.lightImpact();
        final callback = onPressed;
        if (callback != null) {
          callback();
        } else {
          Navigator.of(context).maybePop();
        }
      },
      icon: DecoratedBox(
        decoration: BoxDecoration(
          color: circleColor.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(Icons.arrow_back_rounded, color: iconColor, size: 24),
        ),
      ),
    );
  }
}
