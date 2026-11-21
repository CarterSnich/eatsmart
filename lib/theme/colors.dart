import 'package:flutter/material.dart';
import 'package:isdasmart/theme/dark.dart';
import 'package:isdasmart/theme/light.dart';

class AppColors {
  final Color border;
  final Color sectionLabel;

  const AppColors({required this.border, required this.sectionLabel});

  static AppColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      // Dark
      ? darkColors
      // Light
      : lightColors;
}
