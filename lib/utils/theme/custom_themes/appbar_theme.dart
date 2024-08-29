import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black, size: SizesManager.s25),
      actionsIconTheme:
          IconThemeData(color: Colors.black, size: SizesManager.s25),
      titleTextStyle: TextStyle(
          fontSize: SizesManager.s18,
          fontWeight: FontWeight.w600,
          color: Colors.black));

  static AppBarTheme darkAppBarTheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white, size: SizesManager.s25),
            actionsIconTheme:
      IconThemeData(color: Colors.white, size: SizesManager.s25),
      titleTextStyle: TextStyle(
          fontSize: SizesManager.s18,
          fontWeight: FontWeight.w600,
          color: Colors.white));
}