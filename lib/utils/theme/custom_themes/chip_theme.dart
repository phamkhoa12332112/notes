import 'package:flutter/material.dart';

import '../../resources/sizes_manager.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    backgroundColor: Colors.grey[200]!,
    disabledColor: Colors.grey[300]!,
    selectedColor: Colors.blue[300]!,
    secondarySelectedColor: Colors.blue[200]!,
    labelStyle: const TextStyle(
      color: Colors.black,
    ),
    secondaryLabelStyle: const TextStyle(
      color: Colors.white,
    ),
    padding: EdgeInsets.all(SizesManager.p8),
    shape: const StadiumBorder(),
    brightness: Brightness.light,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    backgroundColor: Colors.grey[800]!,
    disabledColor: Colors.grey[700]!,
    selectedColor: Colors.teal[700]!,
    secondarySelectedColor: Colors.teal[600]!,
    labelStyle: const TextStyle(
      color: Colors.white,
    ),
    secondaryLabelStyle: const TextStyle(
      color: Colors.black,
    ),
    padding: EdgeInsets.all(SizesManager.p8),
    shape: const StadiumBorder(),
    brightness: Brightness.dark,
  );
}