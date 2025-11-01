import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage buildSlideTransitionPage({
  required GoRouterState state,
  required Widget child,
  required ValueKey key,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300), 
    reverseTransitionDuration: const Duration(milliseconds: 300), // Optional: specify duration for pop
    
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeOut;

      // 1. Animation for the INCOMING screen (New Page)
      // Starts off-screen right (Offset(1.0, 0.0)) and ends at center (Offset.zero)
      final incomingTween = Tween(
        begin: const Offset(1.0, 0.0), // Start from right
        end: Offset.zero,             // End in center
      ).chain(CurveTween(curve: curve));

      // 2. Animation for the OUTGOING screen (Current Page)
      // Starts at center (Offset.zero) and ends off-screen left (Offset(-1.0, 0.0))
      final outgoingTween = Tween(
        begin: Offset.zero,           // Start in center
        end: const Offset(-1.0, 0.0), // End to the left
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        // This SlideTransition applies to the new page (`child`)
        position: animation.drive(incomingTween),
        child: SlideTransition(
          // This nested SlideTransition applies the outgoing animation 
          // to the new page's container when the OLD page is moving out.
          // This is what creates the "pushing" effect on the OLD screen.
          position: secondaryAnimation.drive(outgoingTween),
          child: child,
        ),
      );
    },
  );
}