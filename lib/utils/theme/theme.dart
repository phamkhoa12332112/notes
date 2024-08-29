import 'package:flutter/material.dart';
import 'package:notesapp/utils/theme/custom_themes/appbar_theme.dart';
import 'package:notesapp/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:notesapp/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:notesapp/utils/theme/custom_themes/chip_theme.dart';
import 'package:notesapp/utils/theme/custom_themes/floating_button_theme.dart';
import 'package:notesapp/utils/theme/custom_themes/icon_theme.dart';
import 'package:notesapp/utils/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      iconTheme: TIconTheme.lightIconTheme,
      textTheme: TTextTheme.lightTextTheme,
      appBarTheme: TAppBarTheme.lightAppBarTheme,
      bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
      chipTheme: TChipTheme.lightChipTheme,
      checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
      floatingActionButtonTheme: TFloatingButtonTheme.lightFloatingButtonTheme);
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      iconTheme: TIconTheme.darkIconTheme,
      textTheme: TTextTheme.darkTextTheme,
      appBarTheme: TAppBarTheme.darkAppBarTheme,
      chipTheme: TChipTheme.darkChipTheme,
      bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
      checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
      floatingActionButtonTheme: TFloatingButtonTheme.darkFloatingButtonTheme);
}