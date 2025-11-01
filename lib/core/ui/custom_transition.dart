import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Helper function to create a slide-in/slide-out transition page
CustomTransitionPage buildSlideTransitionPage({
  required GoRouterState state,
  required Widget child,
  required ValueKey key,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    // The transition duration for a smooth slide
    transitionDuration: const Duration(milliseconds: 300), 
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Define the direction of the slide: 
      // start at 1.0 (off-screen right), end at 0.0 (on-screen)
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOut;

      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}