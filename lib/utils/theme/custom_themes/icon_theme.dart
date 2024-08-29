import 'package:flutter/material.dart';

class TIconTheme {
  TIconTheme._();

  static IconThemeData lightIconTheme = IconThemeData(
    color: Colors.black, // Color of the icons in light theme
    size: 24.0, // Size of the icons
    opacity: 0.9, // Opacity of the icons
  );

  static IconThemeData darkIconTheme = IconThemeData(
    color: Colors.white, // Color of the icons in dark theme
    size: 24.0, // Size of the icons
    opacity: 0.9, // Opacity of the icons
  );
}