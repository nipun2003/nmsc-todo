// Define your standard radii (x2, x3, etc.)
import 'package:flutter/material.dart';

class AppRadius {
  static const double extraSmall = 4.0; // x2
  static const double small = 8.0; // x3
  static const double medium = 12.0; // x4
  static const double large = 16.0; // x5
}

// Grouping the shapes
class AppShapes {
  static const BorderRadius extraSmall = BorderRadius.all(
    Radius.circular(AppRadius.extraSmall),
  );
  static const BorderRadius small = BorderRadius.all(
    Radius.circular(AppRadius.small),
  );
  static const BorderRadius medium = BorderRadius.all(
    Radius.circular(AppRadius.medium),
  );
  static const BorderRadius large = BorderRadius.all(
    Radius.circular(AppRadius.large),
  );
}
