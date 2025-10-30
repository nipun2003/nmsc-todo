import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/shapes.dart';
import 'package:nmsc_todo/core/ui/size.dart';

// ====================================================================
// 1. SIZE and COLOR CONSTANTS (Derived from x-scale and prior definitions)
// ====================================================================

// From prior definitions: val SuccessColor = Color(0xFF34C759)
const Color _successColor = Color(0xFF34C759);

// ====================================================================
// 2. ENUMS AND EXTENSIONS (NmscButtonType)
// ====================================================================

enum NmscButtonType { primary, secondary, success, error }

extension NmscButtonTypeExtension on NmscButtonType {
  // Equivalent to @Composable fun SplittyButtonType.backgroundColor(): Color
  Color backgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case NmscButtonType.primary:
        return colorScheme.primary;
      case NmscButtonType.secondary:
        // Maps to MaterialTheme.colorScheme.secondary
        return colorScheme.secondary;
      case NmscButtonType.success:
        return _successColor;
      case NmscButtonType.error:
        // Maps to MaterialTheme.colorScheme.errorContainer
        return colorScheme.errorContainer;
    }
  }

  // Equivalent to @Composable fun SplittyButtonType.textColor(): Color
  Color textColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case NmscButtonType.primary:
        return colorScheme.onPrimary;
      case NmscButtonType.secondary:
        return colorScheme.onSecondary;
      case NmscButtonType.success:
        // Success button content should be white/onPrimary for contrast
        return colorScheme.onPrimary;
      case NmscButtonType.error:
        // Maps to MaterialTheme.colorScheme.onErrorContainer
        return colorScheme.onErrorContainer;
    }
  }
}

// ====================================================================
// 3. NMSC BUTTON WIDGET (Corresponds to SplittyButton)
// ====================================================================

class NMSCPrimaryButton extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final NmscButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;

  const NMSCPrimaryButton({
    super.key,
    required this.onClick,
    required this.text,
    this.type = NmscButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 1. Determine colors based on type
    final Color normalBackgroundColor = type.backgroundColor(context);
    final Color normalContentColor = type.textColor(context);

    // 2. Define disabled colors (Mapping Compose theme colors to Flutter theme)
    // disabledContainerColor = MaterialTheme.colorScheme.surfaceDim
    final Color disabledContainerColor = colorScheme.surfaceContainerHighest;
    // disabledContentColor = MaterialTheme.colorScheme.onSurfaceVariant
    final Color disabledContentColor = colorScheme.onSurfaceVariant;

    // 3. Determine onPressed (Disabling if loading or disabled)
    final VoidCallback? onPressed = (isLoading || isDisabled) ? null : onClick;

    // 4. Define the Button Style
    final ButtonStyle style = ButtonStyle(
      // containerColor
      backgroundColor: WidgetStatePropertyAll(
        isDisabled ? disabledContainerColor : normalBackgroundColor,
      ),
      // contentColor
      foregroundColor: WidgetStatePropertyAll(
        isDisabled ? disabledContentColor : normalContentColor,
      ),
      // shape = MaterialTheme.shapes.medium -> RoundedRectangleBorder(radius=x4)
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: AppShapes.large,
        ),
      ),
      // elevation = ButtonDefaults.buttonElevation(defaultElevation = x1)
      elevation: WidgetStateProperty.all<double>(
        isDisabled?AppSize.x_0:AppSize.x_0_5,
      ),
      // contentPadding = PaddingValues(horizontal = x4, vertical = x4)
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          horizontal: AppSize.x_4,
          vertical: AppSize.x_4,
        ),
      ),
      // defaultMinSize(minHeight = x12_5)
      minimumSize: WidgetStateProperty.all<Size>(const Size(0, AppSize.x_12_5)),
      // textStyle = MaterialTheme.typography.labelLarge.copy()
      textStyle: WidgetStateProperty.all<TextStyle>(
        textTheme.labelLarge ?? const TextStyle(),
      ),
    );

    // 5. Build the Button
    return SizedBox(
      // if (isFullWidth) Modifier.fillMaxWidth() else Modifier
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: isLoading
            ? SizedBox(
                // CircularProgressIndicator(strokeWidth = x_0_5, modifier = Modifier.size(x5))
                width: AppSize.x_5,
                height: AppSize.x_5,
                child: CircularProgressIndicator(
                  // color = MaterialTheme.colorScheme.onPrimary (loading indicator should be consistent)
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                  strokeWidth: AppSize.x_0_5,
                ),
              )
            : Text(
                text,
                // TextStyle is applied via the 'style' property above.
              ),
      ),
    );
  }
}
