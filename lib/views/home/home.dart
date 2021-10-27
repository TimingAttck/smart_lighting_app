import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lighting/bloc/preferences/preferences_bloc.dart';
import 'package:smart_lighting/themes/themes.dart';
import 'package:smart_lighting/views/details/details.dart';

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
      cards.add(GestureDetector(
          onTap: () {
            showFlexibleBottomSheet(
              minHeight: 0,
              initHeight: 0.5,
              maxHeight: 1,
              context: context,
              builder: (BuildContext context, ScrollController scrollController, double offset) {
                  return _buildBottomSheet(context, scrollController, offset, item, themeName);
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



Widget _buildBottomSheet(BuildContext context, ScrollController scrollController, double bottomSheetOffset, Activity activity, String themeName) {

  return SafeArea(
    child: Material(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                height: 150,
                child: Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sodales lacus tellus, ac ornare mi tempus ut. Mauris et nunc condimentum, consequat massa vel, tristique nulla. Morbi sit amet egestas est. Integer tortor sapien, fringilla sit amet felis sit amet, imperdiet faucibus tellus. Praesent sodales, tortor non interdum dictum, mi eros varius nisi, vel suscipit dolor tortor vel turpis. Suspendisse sollicitudin congue arcu, sit amet interdum velit fringilla id. Suspendisse sit amet mauris eu lectus vestibulum tempor.",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                      ),
                    )
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    )
                  ),
                  onPressed: () => {

                  },
                  child: const Text("Set as Activity")
              ))
            ]),
      ]))),
    );
}