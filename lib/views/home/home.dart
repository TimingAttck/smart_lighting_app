import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lighting/bloc/preferences/preferences_bloc.dart';
import 'package:smart_lighting/themes/themes.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

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
      body: Padding(padding: const EdgeInsets.fromLTRB(15, 20, 15, 0), child: buildGridView(buildCards(items, theme == ThemeHelper.LightTheme ? "light" : "dark"))),
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

  List<Widget> buildCards(List<Activity> items, themeName) {

    List<Widget> cards = [];

    for (var item in items) {
      cards.add(Card(
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
                child: Image.asset(item.image+"_"+themeName+".png", height: 70),
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
      ));
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