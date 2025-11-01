import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/shapes.dart';
import 'package:nmsc_todo/core/ui/size.dart';

enum NmscButtonType { primary, secondary, success, error }

class NmscButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final NmscButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;
  final Widget? leading;
  final Widget? trailing;

  const NmscButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = NmscButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (bgColor, textColor) = switch (type) {
      NmscButtonType.primary => (colorScheme.primary, colorScheme.onPrimary),
      NmscButtonType.secondary => (colorScheme.secondary, colorScheme.onSecondary),
      NmscButtonType.success => (const Color(0xFF34C759), colorScheme.onPrimary),
      NmscButtonType.error => (colorScheme.errorContainer, colorScheme.onErrorContainer),
    };

    // ✅ Final disabled logic
    final bool disabled = isDisabled || isLoading;
    final background = disabled
        ? colorScheme.surfaceContainerHighest
        : bgColor;
    final foreground = disabled
        ? colorScheme.onSurface.withAlpha(38)
        : textColor;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(background),
          foregroundColor: WidgetStatePropertyAll(foreground),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppShapes.large),
          ),
          padding: WidgetStatePropertyAll(
            const EdgeInsets.symmetric(horizontal: AppSize.x_4, vertical: AppSize.x_4),
          ),
          minimumSize: WidgetStatePropertyAll(const Size(0, AppSize.x_12_5)),
          textStyle: WidgetStatePropertyAll(theme.textTheme.labelLarge),
          elevation: WidgetStatePropertyAll(AppSize.x_0),
        ),
        child: isLoading
            ? SizedBox(
                width: AppSize.x_5,
                height: AppSize.x_5,
                child: CircularProgressIndicator(
                  strokeWidth: AppSize.x_0_5,
                  color: foreground,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: AppSize.x_2),
                  ],
                  Text(text),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSize.x_2),
                    trailing!,
                  ],
                ],
              ),
      ),
    );
  }
}
