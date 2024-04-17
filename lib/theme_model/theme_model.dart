import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void setThemeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
