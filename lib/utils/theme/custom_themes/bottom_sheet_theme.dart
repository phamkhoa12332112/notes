import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';

class TBottomSheetTheme {
  TBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
      backgroundColor: Colors.white,
      modalBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizesManager.s15)));

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
      backgroundColor: Colors.grey,
      modalBackgroundColor: Colors.grey.shade600,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizesManager.s15)));
}