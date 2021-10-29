import 'dart:async';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lighting/bloc/preferences/preferences_bloc.dart';
import 'package:smart_lighting/themes/themes.dart';
import 'package:smart_lighting/views/details/details.dart';
import 'package:smart_lighting/widgets/general/status_button.dart';
import 'package:time_range/time_range.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  StateButtonController stateButtonController = StateButtonController();

  var items = [
    Activity(
        image: "assets/cooking",
        title: "Cooking",
        subtitle: ""
    ),
    Activity(
        image: "assets/reading",
        title: "Reading",
        subtitle: ""
    ),
    Activity(
        image: "assets/workout",
        title: "Workout",
        subtitle: ""
    ),
    Activity(
        image: "assets/screentime",
        title: "Screentime",
        subtitle: ""
    ),
    Activity(
        image: "assets/coding",
        title: "Coding",
        subtitle: ""
    ),
    Activity(
        image: "assets/office_work",
        title: "Office Work",
        subtitle: ""
    ),
    Activity(
        image: "assets/eating",
        title: "Eating",
        subtitle: ""
    ),
  ];

  @override
  Widget build(BuildContext context) {

    ThemeWrapper theme = BlocProvider.of<PreferencesBloc>(context).state.theme;
    IconData iconData = theme == ThemeHelper.LightTheme ? Icons.nightlight_round : Icons.wb_sunny_sharp;

    Scaffold scaffold = Scaffold(
      appBar: AppBar(
        backgroundColor: theme.themeData.appBarTheme.backgroundColor,
        systemOverlayStyle: theme.systemOverlay,
        title: const Text("Activities"),
        toolbarHeight: 75,
        actions: [
          IconButton(onPressed: () {
            ThemeWrapper theme = BlocProvider.of<PreferencesBloc>(context).state.theme;
            if (theme == ThemeHelper.DarkTheme) {
              BlocProvider.of<PreferencesBloc>(context).add(ThemeChanged(theme: ThemeHelper.LightTheme));
            } else {
              BlocProvider.of<PreferencesBloc>(context).add(ThemeChanged(theme: ThemeHelper.DarkTheme));
            }
          }, icon: Icon(iconData) )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: buildGridView(buildCards(items, theme))
      ),
    );

    SystemChrome.setSystemUIOverlayStyle(theme.systemOverlay);

    return scaffold;
  }

  Widget buildGridView(List<Widget> items) => GridView.count(
      clipBehavior: Clip.none,
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      children: items,
      padding: const EdgeInsets.only(bottom: 20),
  );

  List<Widget> buildCards(List<Activity> items, ThemeWrapper themeWrapper) {

    String themeName = themeWrapper == ThemeHelper.LightTheme ? "light" : "dark";
    List<Widget> cards = [];

    for (var item in items) {
      cards.add(GestureDetector(
          onTap: () {
            showFlexibleBottomSheet(
              minHeight: 0,
              initHeight: 0.63,
              maxHeight: 1,
              context: context,
              builder: (BuildContext context, ScrollController scrollController, double offset) {
                  return _buildBottomSheet(context, stateButtonController, scrollController, offset, item, themeWrapper);
              },
              anchors: [0, 0.5, 1],
            );
          },child: Card(
        elevation: 12,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Hero(
                  tag: item.hashCode,
                  child: Image.asset(item.image+"_"+themeName+".png", height: 70)
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(item.title, style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),)
            ],
          ),
        )
      )));
    }

    return cards;

  }

}

class Activity {

  String title;
  String image;
  String subtitle;

  Activity({required this.title, required this.image, required this.subtitle});

}

StateButton _buildSetActivityButton(BuildContext context, ThemeWrapper theme, StateButtonController stateButtonController) {

  return StateButton(
    disabled: true,
    alignment: Alignment.bottomRight,
    height: 40,
    child: const Text(
      "Set Activity",
      style: TextStyle(
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
      textScaleFactor: 1.0,
    ),
    controller: stateButtonController,
    onPressed: () {
      stateButtonController.start();
      Timer(const Duration(seconds: 3), () {
        stateButtonController.success();
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      });
    },
    backgroundColor: theme.themeData.accentColor,
    borderRadius: 8,
  );

}

Widget _buildBottomSheet(BuildContext context, StateButtonController stateButtonController, ScrollController scrollController, double bottomSheetOffset, Activity activity, ThemeWrapper themeWrapper) {

  DateTime now = DateTime.now();

  String themeName = themeWrapper == ThemeHelper.LightTheme ? "light" : "dark";
  StateButton stateButton = _buildSetActivityButton(context, themeWrapper, stateButtonController);

  return SafeArea(
    child: Material(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
          Positioned(
              top: -100,
              left: 0,
              right: 0,
              child: Image.asset(activity.image+"_"+themeName+"_uniform.png", height: 190)
          ),
          Column(
            children:  [
              const SizedBox(
                height: 80,
              ),
              Container(
                padding: const EdgeInsets.only(left:15, right: 15, bottom: 15),
                width: double.infinity,
                child: Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 75,
                child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sodales lacus tellus, ac ornare mi tempus ut. Integer sodales lacus tellus, ac ornare mi tempus ut.",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            maxLines: 3,
                          )
                      ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TimeRange(
                    fromTitle: const Text(
                      'FROM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    toTitle: const Text(
                      'TO',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    borderColor: themeWrapper.timeSelectBorder,
                    activeBorderColor: themeWrapper.activetimeSelectBorder,
                    activeBackgroundColor: themeWrapper.activetimeSelectBackground,
                    backgroundColor: Colors.transparent,
                    activeTextStyle: themeWrapper.activeTimeSelectTextStyle,
                    firstTime: TimeOfDay(hour: now.hour, minute: 00),
                    lastTime: const TimeOfDay(hour: 24, minute: 00),
                    timeBlock: 20,
                    timeStep: 20,
                    onRangeCompleted: (range) => {
                      stateButton.controller.enable()
                    },
                  )
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: SizedBox(
                      width: 110,
                      child: stateButton
                  )
              )
            ]),
      ]))),
    );
}