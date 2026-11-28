import 'package:flutter/material.dart';

import '../helpers.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode;

  ThemeProvider({required this.themeMode});

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    storageWrite('theme_mode', mode.index);
    notifyListeners();
  }
}
