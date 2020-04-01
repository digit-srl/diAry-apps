import 'package:diary/presentation/pages/home/widgets/beta_card.dart';
import 'package:diary/application/root_elevation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/presentation/pages/settings/settings_page.dart';
import '../logs_page.dart';
import '../slices_page.dart';
import 'package:provider/provider.dart';
import 'widgets/activation_card.dart';
import 'widgets/daily_stats.dart';
import 'widgets/gps_card.dart';
import 'widgets/place_legend.dart';

class NoRippleOnScrollBehavior extends ScrollBehavior {
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

  ScrollController _controller;
  final double elevationOn = 4;
  final double elevationOff = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    Provider.of<RootElevationNotifier>(context, listen: false).changeElevationIfDifferent(0, 0);
  }

  void _scrollListener() {
    double newElevation = _controller.offset > 1 ? elevationOn : elevationOff;
    Provider.of<RootElevationNotifier>(context, listen: false).changeElevationIfDifferent(0, newElevation);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
          behavior: NoRippleOnScrollBehavior(),
          child: ListView(
            controller: _controller,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top + 20, // top padding calcolato in relazione alla dimensione della srtatusbar (che può variare)
              ),
              DailyStats(),

//              CarCard(),
              GpsCard(),
              ActivationCard(),
              BetaCard(),
              // WomCard(),
//              PlaceLegend(),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      bottomNavigationBar: Material(
        elevation: 16,
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
                    width: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF2F7),
                      //border: Border.all(width: 1.0),
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
                    width: 8,
                  ),
                  IconButton(
                    icon: Icon(Icons.cloud_upload),
                    color: accentColor,
                    iconSize: 28,
                    onPressed: () {},
                    tooltip: "Coming soon!",
                  ),

                  IconButton(
                    icon: Icon(Icons.settings),
                    color: accentColor,
                    iconSize: 28,
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
    );
  }
}
