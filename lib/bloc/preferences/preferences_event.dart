part of 'preferences_bloc.dart';

///
/// Preferences BLoC
/// Declares the different Events that may happen
///
@immutable
abstract class PreferencesEvent {}

class ThemeChanged extends PreferencesEvent {
  final ThemeWrapper theme;

  ThemeChanged({required this.theme});
}

class LanguageChanged extends PreferencesEvent {
  final Locale locale;

  LanguageChanged({required this.locale});
}

class QuickViewPreferenceChanged extends PreferencesEvent {
  final bool quickAccessDefaultViewWhenNotEmpty;

  QuickViewPreferenceChanged({required this.quickAccessDefaultViewWhenNotEmpty});
}