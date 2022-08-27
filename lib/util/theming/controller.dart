import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palhetas/values/colors.dart';

///Theming Controller
/// - Change Theme Instantly
/// - Auto-Detect System Theme
class ThemeController {
  ///Get System Theme
  static AdaptiveThemeMode systemTheme() {
    return AdaptiveThemeMode.system;
  }

  ///Change Theme
  /// - `context` => Current Context (BuildContext)
  /// - `newTheme` => New Theme (Bool)
  ///
  /// If `newTheme` is `true`, Dark Theme will be enabled.
  static void changeTheme({
    required BuildContext context,
    required bool newTheme,
  }) {
    if (newTheme) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
  }

  ///Easy Toggle
  /// - Change the Theme Automatically
  static Future<void> easyToggle({required BuildContext context}) async {
    AdaptiveTheme.of(context).toggleThemeMode();

    setStatusAndNav(
      themeMode: await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.system,
    );
  }

  static void setStatusAndNav({
    required AdaptiveThemeMode themeMode,
  }) async {
    if (themeMode == AdaptiveThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.mainColors["scaffold_dark"],
          statusBarColor: AppColors.mainColors["status_bar_dark"],
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.mainColors["scaffold_light"],
          statusBarColor: AppColors.mainColors["status_bar_light"],
        ),
      );
    }
  }
}
