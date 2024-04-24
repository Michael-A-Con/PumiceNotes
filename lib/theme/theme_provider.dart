import 'package:flutter/material.dart';
import 'package:minimal_notes_app/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  //initial theme light
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  ThemeProvider({required bool isDarkMode}) {
    _themeData = isDarkMode ? darkMode : lightMode;
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeData == lightMode) {
      _themeData = darkMode;
      prefs.setBool("isDarkTheme", true);
    } else {
      _themeData = lightMode;
      prefs.setBool("isDarkTheme", false);
    }
    notifyListeners();
  }
}