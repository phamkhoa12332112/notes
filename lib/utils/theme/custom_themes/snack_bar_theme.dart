import 'package:flutter/material.dart';

import '../../resources/sizes_manager.dart';

class TSnackBar {
  TSnackBar._();

  static SnackBarThemeData lightSnackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.greenAccent,
    elevation: 0,
    showCloseIcon: true,
    closeIconColor: Colors.black,
    contentTextStyle: TextStyle(
        fontSize: SizesManager.s15,
        color: Colors.black),
  );

  static SnackBarThemeData darkSnackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.green[800],
    elevation: 0,
    showCloseIcon: true,
    closeIconColor: Colors.white,
    contentTextStyle: TextStyle(
        fontSize: SizesManager.s15,
        color: Colors.white),
  );
}