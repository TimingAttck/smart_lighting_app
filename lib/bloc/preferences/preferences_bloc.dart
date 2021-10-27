import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_lighting/data/persistance/preferences_persist.dart';
import 'package:smart_lighting/themes/navigation_bar_theme_helper.dart';
import 'package:smart_lighting/themes/themes.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

///
/// Preferences BLoC
/// Handles Preference Changes from the User and reacts to them
/// 
class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {

  PreferencesState startUpState;
  late NavigationBarThemeHelper navigationBarThemeHelper;

  PreferencesBloc({required this.startUpState});

  @override
  PreferencesState get initialState {

    navigationBarThemeHelper = NavigationBarThemeHelper(startUpState.theme.systemOverlay);

    return startUpState;
  }

  @override
  Stream<PreferencesState> mapEventToState(PreferencesEvent event) async* {
    if (event is ThemeChanged) {
        await PreferencesPersistenceHelper.persistPreferencesTheme(event.theme);
        yield PreferencesState(theme: event.theme);

        navigationBarThemeHelper.setSystemUiOverlayStyle(state.theme.systemOverlay);
        navigationBarThemeHelper.applyTheme();
    }
  }

}