import 'package:flutter/material.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/presentation/pages/settings/settings_page.dart';
import '../logs_page.dart';
import '../slices_page.dart';
import 'widgets/activation_card.dart';
import 'widgets/daily_stats.dart';
import 'widgets/gps_card.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 65, 16, 0),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: <Widget>[
              DailyStats(),
              SizedBox(
                height: 5,
              ),
//              CarCard(),
              GpsCard(),
              ActivationCard(),
//              PlaceLegend(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 15,
        color: Colors.white,
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
                          builder: (BuildContext context) => TabBarDemo(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: accentColor,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.bug_report),
                    color: accentColor,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LogsPage(),
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
    );
  }
}
