import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Themes { dark, light }

class ThemeWrapper {
  Themes themeIdentifier;
  ThemeData themeData;
  Color accentTextColor;
  Color tabBarContentsColor;
  Color opposite;
  Color main;
  Color titleColor;
  Color bottomNavigationBarColor;
  SystemUiOverlayStyle systemOverlay;

  ThemeWrapper(
      { required this.main,
        required this.themeIdentifier,
        required this.themeData,
        required this.systemOverlay,
        required this.accentTextColor,
        required this.tabBarContentsColor,
        required this.bottomNavigationBarColor,
        required this.titleColor,
        required this.opposite });
}

///
/// A helper class for System Themes and helpers for translations of a theme from and to persistant storage
///
class ThemeHelper {
  static final DarkTheme = ThemeWrapper(
    accentTextColor: Colors.white,
    themeIdentifier: Themes.dark,
    tabBarContentsColor: Colors.white,
    opposite: Colors.white,
    main: Color(0xFF212121),
    titleColor: Colors.white,
    bottomNavigationBarColor: const Color(0xFF212121),
    themeData: ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xFF1976D2),
            textStyle: const TextStyle(
              color: Colors.white
            )
        ),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(elevation: 0),
      bottomAppBarColor: const Color(0xFF212121),
      scaffoldBackgroundColor: const Color(0xFF212121),
      brightness: Brightness.dark, 
      accentColor: const Color(0xFF1976D2),
      appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Color(0xFF212121)),
    ),
    systemOverlay: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF212121),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Color(0xFF212121),
    ),
  );

  static final LightTheme = ThemeWrapper(
      accentTextColor: Colors.white,
      themeIdentifier: Themes.light,
      titleColor: const Color(0xFF1976D2),
      opposite: const Color(0xFF5151511),
      main: Colors.white,
      tabBarContentsColor: const Color(0xFF1976D2),
      bottomNavigationBarColor: Colors.white,
      themeData: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: const Color(0xFF1976D2),
              onPrimary: Colors.white
          ),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          surface: Colors.white,
          onSurface: Color(0xFF212121),
          primary: Colors.white,
          onPrimary: Color(0xFF212121),
          primaryVariant: Colors.grey,
          secondary: Colors.grey,
          secondaryVariant: Colors.grey,
          onSecondary: Colors.white,
          background: Colors.grey,
          onBackground: Colors.grey,
          error: Colors.grey,
          onError: Colors.grey,
        ),
        bottomAppBarColor: Colors.white,
        brightness: Brightness.light,
        accentColor: const Color(0xFF1976D2),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Colors.white),
      ),
      systemOverlay: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));

  static ThemeWrapper themeFromString(String themeString) {
    switch (themeString) {
      case "dark":
        return DarkTheme;
        break;
      case "light":
        return LightTheme;
        break;
      default:
        return LightTheme;
    }
  }

  static String stringFromTheme(ThemeWrapper themeWrapper) {
    switch (themeWrapper.themeIdentifier) {
      case Themes.dark:
        return "dark";
        break;
      case Themes.light:
        return "light";
        break;
      default:
        return "light";
    }
  }
}
