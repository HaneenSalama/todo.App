import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SettingsProvider() {
    getLanguage();
    getTheme();
  }
  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'en';

  bool get isDark => themeMode == ThemeMode.dark;

  void changeTheme(ThemeMode selectedTheme) {
    themeMode = selectedTheme;
    saveTheme(themeMode);
    notifyListeners();
  }

  void saveTheme(ThemeMode theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (theme == ThemeMode.light) {
      prefs.setString('theme', 'light');
    } else {
      prefs.setString('theme', 'dark');
    }
  }

  void getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String cachedTheme = prefs.getString('theme') ?? 'light';
    if (cachedTheme == 'light') {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  void changeLanguage(String selectedLanguage) {
    if (selectedLanguage == languageCode) return;
    languageCode = selectedLanguage;
    saveLanguage(languageCode);
    notifyListeners();
  }

  void saveLanguage(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (language == 'en') {
      prefs.setString('language', 'en');
    } else {
      prefs.setString('language', 'ar');
    }
  }

  void getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('language') ?? 'en';
    if (lang == 'en') {
      languageCode = 'en';
    } else {
      languageCode = 'ar';
    }
    notifyListeners();
  }
}
