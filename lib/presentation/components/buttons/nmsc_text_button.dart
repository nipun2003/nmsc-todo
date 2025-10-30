import 'package:flutter/material.dart';

// ====================================================================
// 1. ENUMS AND EXTENSIONS (Mapping Compose Type and Size)
// ====================================================================

// Equivalent to sealed class SplittyTextButtonType
enum NMSCTextButtonType { primary, pink, error }

extension NMSCTextButtonTypeExtension on NMSCTextButtonType {
  // Equivalent to @Composable fun SplittyTextButtonType.textColor(): Color
  Color textColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case NMSCTextButtonType.primary:
        return colorScheme.primary;
      case NMSCTextButtonType.pink:
      // Assuming 'tertiary' corresponds to the Pink color defined in your theme
        return colorScheme.tertiary;
      case NMSCTextButtonType.error:
        return colorScheme.error;
    }
  }
}

// Equivalent to enum class SplittyTextButtonSize
enum SplittyTextButtonSize { small, normal, medium, large }

extension SplittyTextButtonSizeExtension on SplittyTextButtonSize {
  // Equivalent to @Composable fun SplittyTextButtonSize.fontWeight(): FontWeight
  FontWeight get fontWeight {
    switch (this) {
      case SplittyTextButtonSize.large:
        return FontWeight.bold;    // w700
      case SplittyTextButtonSize.medium:
        return FontWeight.w600;   // SemiBold
      case SplittyTextButtonSize.small:
        return FontWeight.w500;    // Medium
      case SplittyTextButtonSize.normal:
        return FontWeight.normal;  // w400
    }
  }
}

// ====================================================================
// 2. SPLITTY TEXT BUTTON WIDGET
// ====================================================================

class NMSCTextButton extends StatelessWidget {
  // Equivalent to @StringRes text
  final String text;
  // Equivalent to onClick
  final VoidCallback onClick;
  final NMSCTextButtonType type;
  final SplittyTextButtonSize size;
  final bool isDisabled;
  // Equivalent to PaddingValues (x0 is assumed to be 0.0)
  final EdgeInsets padding;
  // Equivalent to style: TextStyle = MaterialTheme.typography.bodyMedium
  final TextStyle? customStyle;

  const NMSCTextButton({
    super.key,
    required this.text,
    required this.onClick,
    this.type = NMSCTextButtonType.primary,
    this.size = SplittyTextButtonSize.normal,
    this.isDisabled = false,
    this.padding = EdgeInsets.zero, // x0, x0 padding
    this.customStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 1. Determine Text Color (Handling isDisabled state)
    final Color textColor = isDisabled
        ? colorScheme.onSurfaceVariant
        : type.textColor(context);

    // 2. Determine Font Weight (from size enum)
    final FontWeight fontWeight = size.fontWeight;

    // 3. Base TextStyle (defaults to bodyMedium in Compose)
    final TextStyle baseStyle = customStyle ?? textTheme.bodyMedium ?? const TextStyle();

    // 4. Final TextStyle with custom fontWeight merged
    final TextStyle finalTextStyle = baseStyle.copyWith(
      fontWeight: fontWeight,
      color: textColor, // Set the text color directly
    );

    // 5. Determine onPressed (Handling isDisabled state)
    final VoidCallback? onPressed = isDisabled ? null : onClick;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        // Set transparent background (matches Compose Surface color = Color.Transparent)
        backgroundColor: Colors.transparent,
        // foregroundColor controls text color when enabled/focused, and the ripple color
        foregroundColor: textColor,
        // Set padding
        padding: padding,
        // Disable default tap/hover overlay if button is disabled
        overlayColor: isDisabled ? Colors.transparent : null,
        // Apply the final text style
        textStyle: finalTextStyle,
      ),
      child: Text(
        text,
        // Flutter TextButton takes the text style from TextButton.styleFrom,
        // so no need to set style here.
      ),
    );
  }
}
