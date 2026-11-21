import 'package:flutter/material.dart';
import 'package:isdasmart/theme/colors.dart';

final lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: "Commissioner",
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  primaryColor: Color.fromARGB(255, 0, 135, 197),
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white.withValues(alpha: 0.08),
  iconTheme: IconThemeData(color: const Color(0xDDDDDDff)),
  shadowColor: Colors.black,
);

final lightColors = AppColors(
  border: const Color(0xDDDDDDff),
  sectionLabel: Color.fromARGB(255, 0, 135, 197),
);
