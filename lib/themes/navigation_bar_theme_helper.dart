import 'package:flutter/services.dart';

///
/// This class is a helper class for applying a theme for the native system navigation bar
///
class NavigationBarThemeHelper {
  SystemUiOverlayStyle _systemUiOverlayStyle;

  NavigationBarThemeHelper(SystemUiOverlayStyle systemUiOverlayStyle)
      : _systemUiOverlayStyle = systemUiOverlayStyle;

  void setSystemUiOverlayStyle(SystemUiOverlayStyle systemUiOverlayStyle) =>
      _systemUiOverlayStyle = systemUiOverlayStyle;

  void applyTheme() {
    // Apply SystemOverlay
    SystemChrome.setSystemUIOverlayStyle(_systemUiOverlayStyle);
  }

}