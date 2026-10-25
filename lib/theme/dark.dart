import 'package:eatsmart/theme/colors.dart';
import 'package:flutter/material.dart';

final darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: "Commissioner",
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: Color(0xFF08111F),
  cardColor: Colors.white.withValues(alpha: 0.08),
  iconTheme: IconThemeData(color: Colors.white70),
);

final darkColors = AppColors(
  border: Colors.white70,
  sectionLabel: Color.fromARGB(255, 125, 211, 252),
);
