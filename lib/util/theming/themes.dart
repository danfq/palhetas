import 'package:flutter/material.dart';
import 'package:palhetas/values/colors.dart';

///App Themes
/// - Follows the MDDM Model
/// - Dark & Light
/// - Material 3
class Themes {
  ///Light Theme
  static ThemeData light() {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.mainColors["scaffold_light"],
      appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: AppColors.mainColors["appbar_light"],
      ),
    );
  }

  ///Dark Theme
  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.mainColors["scaffold_dark"],
      appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: AppColors.mainColors["appbar_dark"],
      ),
    );
  }
}
