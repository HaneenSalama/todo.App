import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xff5D9CEC);
  static const Color backgroundLight = Color(0xffDFECDB);
  static const Color backgroundDark = Color(0xff060E1E);
  static const Color black = Color(0xff363636);
  static const Color blueBlack = Color(0xff141922);
  static const Color white = Color(0xffffffff);
  static const Color gray = Color(0xffC8C9CB);
  static const Color green = Color(0xff61E757);
  static const Color red = Color(0xffEC4B4B);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
    scaffoldBackgroundColor: backgroundLight,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: white,
      selectedItemColor: primary,
      unselectedItemColor: gray,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
      shape: CircleBorder(
        side: BorderSide(
          color: white,
          width: 4,
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        shape: const StadiumBorder(),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primary,
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
    scaffoldBackgroundColor: backgroundDark,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: blueBlack,
      selectedItemColor: primary,
      unselectedItemColor: gray,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
      shape: CircleBorder(
        side: BorderSide(
          color: blueBlack,
          width: 4,
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        shape: const StadiumBorder(),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
  );
}
