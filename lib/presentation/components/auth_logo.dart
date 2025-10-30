import 'package:flutter/material.dart';
import 'package:nmsc_todo/core/ui/size.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the primary color from the active theme
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    // Outer Box (Border and Padding)
    return Container(
      // The outer border uses 'extraLarge' shape, which corresponds to CircleShape.
      // We use BoxDecoration with BoxShape.circle for this.
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: AppSize.x_2,
          // primary.copy(alpha = 0.4f) -> primary.withOpacity(0.4)
          color: primaryColor.withAlpha(40),
        ),
      ),
      // .padding(x1)
      padding: const EdgeInsets.all(AppSize.x_1),

      // Inner Content Box
      child: SizedBox(
        // modifier = Modifier.size(x12_5)
        width: AppSize.x_12_5,
        height: AppSize.x_12_5,

        // contentAlignment = Alignment.Center
        child: Center(
          child: Image.asset(
            // NOTE: Replace 'assets/login_logo.png' with your actual asset path
            'assets/img/logo.png',
            // modifier = Modifier.size(x6)
            width: AppSize.x_8,
            height: AppSize.x_8,
            // alignment = Alignment.Center is default in Flutter Image
            // contentScale = ContentScale.Crop -> fit: BoxFit.cover
            fit: BoxFit.cover,
            // contentDescription = stringResource(R.string.login_logo_description)
            semanticLabel: 'Login logo description',
          ),
        ),
      ),
    );
  }
}
