import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/size.dart';

class GoogleLogin extends StatelessWidget {
  final VoidCallback? onPressed;
  const GoogleLogin({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // If 'full' is true, set the width to double.infinity (full available width)
      // Otherwise, keep the width null, letting the ElevatedButton size itself based on content.
      width: double.infinity,
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
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          overlayColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.surfaceContainer.withAlpha(80),
          ),
          elevation: const WidgetStatePropertyAll(0),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/img/google.webp',
              height: AppSize.x_6,
              width: AppSize.x_6,
            ),
            const SizedBox(width: AppSize.x_4),
            Text(
              'Sign in with Google',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
