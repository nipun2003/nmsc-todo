import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/size.dart';

// ====================================================================
// 1. SIZE and SHAPE CONSTANTS (Combined for self-containment)
// ====================================================================


// Equivalent to AppShapes.medium (assumed x4 = 16.0 radius from earlier)
final BorderRadius _mediumBorderRadius = BorderRadius.circular(AppSize.x_4);

// ====================================================================
// 2. GOOGLE LOGIN BUTTON WIDGET
// ====================================================================

class GoogleLogin extends StatelessWidget {
  final VoidCallback onClick;

  const GoogleLogin({
    super.key,
    required this.onClick,
  });

  // Helper to determine custom elevation based on state
  WidgetStateProperty<double> _resolveElevation() {
    return WidgetStateProperty.resolveWith<double>(
          (Set<WidgetState> states) {
        // Map Compose elevations:
        // defaultElevation = x0
        // pressedElevation = x1 (4.0)
        // hoveredElevation = x_0_5 (2.0)
        // focusedElevation = x1 (4.0)
        if (states.contains(WidgetState.pressed)) {
          return AppSize.x_1; // 4.0
        }
        if (states.contains(WidgetState.hovered)) {
          return AppSize.x_0_5; // 2.0
        }
        if (states.contains(WidgetState.focused)) {
          return AppSize.x_1; // 4.0
        }
        return AppSize.x_0; // 0.0
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 1. Define the Button Style
    final ButtonStyle style = ButtonStyle(
      // containerColor = MaterialTheme.colorScheme.background (White)
      backgroundColor: WidgetStateProperty.all<Color>(colorScheme.surface),
      // contentColor = MaterialTheme.colorScheme.onSecondary (Subdued text color)
      foregroundColor: WidgetStateProperty.all<Color>(colorScheme.onSecondary),

      // shape = MaterialTheme.shapes.medium
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: _mediumBorderRadius,
        ),
      ),
      minimumSize: WidgetStatePropertyAll(Size.zero),

      // border = BorderStroke(width = x_0_25, color = MaterialTheme.colorScheme.outline)
      side: WidgetStateProperty.all<BorderSide>(
        BorderSide(
          width: AppSize.x_0_25, // 1.0
          color: colorScheme.outline,
        ),
      ),

      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          horizontal: AppSize.x_4, // 16.0
          vertical: AppSize.x_3, // 12.0
        ),
      ),

      // elevation = Custom resolver
      elevation: _resolveElevation(),

      // textStyle = MaterialTheme.typography.labelMedium.copy(color = onSecondary)
      textStyle: WidgetStateProperty.all<TextStyle>(
        textTheme.labelMedium!.copyWith(
          color: colorScheme.onSecondary,
        ),
      ),

      // pointerHoverIcon(PointerIcon.Hand) -> SystemMouseCursors.click
      mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
    );

    // 2. Build the Button
    return SizedBox(
      // fillMaxWidth()
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        style: style,
        child: Row(
          // verticalAlignment = Alignment.CenterVertically
          mainAxisAlignment: MainAxisAlignment.start, // horizontalArrangement = Arrangement.Start
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SvgImage (Placeholder: FontAwesome Google Icon)
            Image.asset(
              'assets/img/google.webp',
              height: AppSize.x_6,
              width: AppSize.x_6,
            ),

            // Spacer(modifier = Modifier.width(x5))
            const SizedBox(width: AppSize.x_5), // x5 width spacer

            // Text
            Text(
              "Continue with Google",
              // Style is applied via the ButtonStyle textStyle property.
            ),
          ],
        ),
      ),
    );
  }
}
