import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode;

  ThemeProvider({required this.themeMode});

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    GetStorage().write('theme_mode', mode.index);
    notifyListeners();
  }
}
