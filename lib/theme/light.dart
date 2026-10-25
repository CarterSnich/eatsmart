import 'package:eatsmart/theme/colors.dart';
import 'package:flutter/material.dart';

final lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: "Commissioner",
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white.withValues(alpha: 0.08),
  iconTheme: IconThemeData(color: const Color(0xDDDDDDff)),
);

final lightColors = AppColors(
  border: const Color(0xDDDDDDff),
  sectionLabel: Color.fromARGB(255, 0, 135, 197),
);
