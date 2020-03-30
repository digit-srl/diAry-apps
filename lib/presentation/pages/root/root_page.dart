import 'package:diary/presentation/pages/annotations/annotations_page.dart';
import 'package:flutter/material.dart';
import 'package:diary/presentation/pages/home/home_page.dart';
import 'package:diary/presentation/widgets/my_day_app_bar.dart';

import '../map/map_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            IndexedStack(
              index: _index,
              children: <Widget>[
                HomePage(),
                MapPage(),
                AnnotationsPage(),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: MyDayAppBar(changePage: changePage),
            ),
          ],
        ),
      ),
    );
  }

  changePage(int index) {
    setState(() {
      _index = index;
    });
  }
}