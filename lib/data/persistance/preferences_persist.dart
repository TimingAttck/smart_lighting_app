import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_lighting/bloc/preferences/preferences_bloc.dart';
import 'dart:async';

import 'package:smart_lighting/themes/themes.dart';

import '../../constants.dart';

///
/// This class handles persisting of the different preferences properties
/// and loading of the preferences from shared preferences
///
class PreferencesPersistenceHelper {

  static Future<void> persistQuickViewPreference(bool quickAccessDefaultViewWhenNotEmpty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("quickAccessDefaultViewWhenNotEmpty", quickAccessDefaultViewWhenNotEmpty);
  }

  static Future<void> persistPreferencesTheme(ThemeWrapper themeWrapper) async {
    String identifier = ThemeHelper.stringFromTheme(themeWrapper); 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("theme", identifier);
  }

  static Future<void> persistPreferencesLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language", language);
  }

  static Future<PreferencesState> getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeWrapper theme = ThemeHelper.themeFromString(prefs.getString("theme") ?? DEFAULT_THEME);
    return PreferencesState(theme: theme);
  }

}