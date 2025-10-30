import 'package:flutter/material.dart';
// Assuming 'package:nmsc_todo/core/ui/size.dart' defines AppSize
import 'package:nmsc_todo/core/ui/size.dart'; // Placeholder/Original import

class NmscPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  // 1. Add the new parameter
  final bool full;

  const NmscPrimaryButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.full = false, // Set a default value of false
  });

  @override
  Widget build(BuildContext context) {
    // 2. Conditionally wrap the ElevatedButton
    return SizedBox(
      // If 'full' is true, set the width to double.infinity (full available width)
      // Otherwise, keep the width null, letting the ElevatedButton size itself based on content.
      width: full ? double.infinity : null,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            const EdgeInsets.symmetric(
              vertical: AppSize.x_2,
              horizontal: AppSize.x_5,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.x_2),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.primary,
          ),
          overlayColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.primaryContainer,
          ),
          elevation: const WidgetStatePropertyAll(0),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
