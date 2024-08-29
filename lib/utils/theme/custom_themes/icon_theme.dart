import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';

class TIconTheme {
  TIconTheme._();

  static IconThemeData lightIconTheme = IconThemeData(
    color: Colors.black,
    size: SizesManager.s25,
    opacity: 0.9,
  );

  static IconThemeData darkIconTheme = IconThemeData(
    color: Colors.white,
    size: SizesManager.s25,
    opacity: 0.9,
  );
}