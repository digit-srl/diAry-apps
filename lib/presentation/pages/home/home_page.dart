import 'package:diary/presentation/pages/annotations/annotations_page.dart';
import 'package:diary/presentation/pages/home/widgets/activation_card.dart';
import 'package:diary/presentation/pages/home/widgets/daily_stats.dart';
import 'package:diary/presentation/pages/home/widgets/gps_card.dart';
import 'package:diary/presentation/pages/home/widgets/place_legend.dart';
import 'package:diary/presentation/pages/map/map_page.dart';
import 'package:diary/presentation/pages/settings/settings_page.dart';
import 'package:diary/presentation/widgets/calendar_button.dart';
import 'package:diary/presentation/widgets/main_fab_button.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../slices_page.dart';

class HomeScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: MainFabButton(),
      body: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: CalendarButton(),
          leading: IconButton(
            icon: const Icon(Icons.map),
            color: accentColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MapPage(),
                ),
              );
            },
            tooltip: "Mappa",
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.collections_bookmark),
              color: accentColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AnnotationsPage(),
                  ),
                );
              },
              tooltip: "Segnalazioni",
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ScrollConfiguration(
            behavior:
            HomeScrollBehavior(), // disabilita il ripple da scorrimento
            child: ListView(
              // controller: _controller, // pone automaticam. ombreggiatura, da fixare
              children: <Widget>[
                DailyStats(),
                SizedBox(
                  height: 5,
                ),
//              CarCard(),
                GpsCard(),
                ActivationCard(),
                PlaceLegend(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
          elevation: 4,
          child: Container(
            height: 60 + MediaQuery.of(context).padding.bottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF2F7),
                        border: Border.all(width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/wom_pin.png',
                              width: 25,
                            ),
                            Text(
                              '-',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(Icons.cloud_upload),
                      color: accentColor,
                      iconSize: 30,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.list),
                      color: accentColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SlicesPage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      color: accentColor,
                      iconSize: 30,
                      tooltip: "Impostazioni",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
