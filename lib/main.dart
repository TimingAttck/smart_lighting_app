import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lighting/views/home/home.dart';

import 'bloc/preferences/preferences_bloc.dart';
import 'data/persistance/preferences_persist.dart';

void main() {
  runApp(const LightingApp());

  // Lock device orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class LightingApp extends StatefulWidget {

  const LightingApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LightingApp();
  }
}

class _LightingApp extends State<LightingApp> {
  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.renderView.automaticSystemUiAdjustment = false;

    ///
    /// FutureBuilder that waits until the preferences were loaded from shared preferences
    /// During the wait time a simple circular progress bar is shown
    /// The data from the preferences is available in every other widget in the application
    /// Applying Theming and language automatically
    ///
    return FutureBuilder<PreferencesState>(
        future: PreferencesPersistenceHelper.getPreferences(),
        builder: (BuildContext context, AsyncSnapshot<PreferencesState> snapshot) {
          if (snapshot.hasData) {

            return BlocProvider(
                create: (context) => PreferencesBloc(startUpState: snapshot.requireData),
                child: BlocBuilder<PreferencesBloc, PreferencesState>(

                  // Build the Application
                    builder: (BuildContext context, PreferencesState state) {

                      return _build(context, state);

                    }
                )
            );

          } else if (snapshot.hasError) {

            return MaterialApp(
                home: Scaffold(
                    body: SafeArea(
                        child:Center(child:
                        Card(child: Column(children: <Widget>[
                          Text("Error has occured while trying to fetch preferences"),
                          Text("Details: ${snapshot.error}")
                        ])))))
            );

          } else {

            // During the loading of the shared preferences show a loading dialog
            return const MaterialApp(
                home: Scaffold(
                    body: SafeArea(
                      child: Center(child: CircularProgressIndicator()),
                    )
                )
            );
          }

        });
  }
}

Widget _build(BuildContext context, PreferencesState state, {bool androidIntentReceived = false}) {
  return MaterialApp(
      title: "",
      // navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: state.theme.themeData,

      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {

        /// A collection of all named routes and their backing Screens
        var routes = <String, WidgetBuilder>{
          '/home': (context) => Home()
        };

        WidgetBuilder? builder = routes[settings.name];

        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (ctx) => builder!(ctx)
        );
      },
      home: Home()
  );
}
