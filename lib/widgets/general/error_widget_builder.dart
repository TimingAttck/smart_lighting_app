import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lighting/bloc/preferences/preferences_bloc.dart';

///
/// Default Error Builder that will be shown when an error occurs in the application
/// Used by all views
///
Widget appErrorWidgetBuilder(FlutterErrorDetails details) => ErrorScreen(details);

class ErrorScreen extends StatelessWidget{

  final FlutterErrorDetails details;
  ErrorScreen(this.details);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(BlocProvider.of<PreferencesBloc>(context).state.theme.systemOverlay);

      return Scaffold(body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
              children: <Widget>[
                Container(
                  color: Colors.redAccent,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Error",
                      style: TextStyle(color: Colors.white),
                      textScaleFactor: 1.4,
                    )
                  )
                ),
                const Padding(padding: EdgeInsets.only(top: 14)),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Text(details.toString())
                  )
                )
              ]
            )
          )));
  }

}