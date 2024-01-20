import 'package:flutter/material.dart';
import 'package:lev_mobile/styling/colors.dart';

const String fontName = 'Ubuntu';

class AppTheme {

  static ThemeData light() {
    return ThemeData(
        useMaterial3: false,
        fontFamily: fontName,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: AppColors.primary,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: const TextStyle(color: AppColors.primary),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIconColor: AppColors.primary.withOpacity(0.5),
          prefixIconColor: AppColors.primary.withOpacity(0.5),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1.0),
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith(
                (states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.primary;
              }
              return AppColors.primary;
            },
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primary,
        ));
  }

  static ThemeData dark() {
    return ThemeData.dark();
  }
}