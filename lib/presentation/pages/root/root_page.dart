import 'package:diary/application/current_root_page_notifier.dart';
import 'package:diary/presentation/pages/annotations/annotations_page.dart';
import 'package:flutter/material.dart';
import 'package:diary/presentation/pages/home/home_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:diary/presentation/widgets/my_day_app_bar.dart';

import '../map/map_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    int _currentPage = context.watch<CurrentRootPageState>().currentPage;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        // i campi di status e navigation bar a volte diventano bianchi.
        // annotatedRegion in questa configurazione risolve il bug
        // https://github.com/flutter/flutter/issues/21265#issuecomment-500142587
        value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light: Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Theme.of(context).primaryColor,
    systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ),
    child:

      WillPopScope(
      onWillPop: () => goBackToHomeOrExit(context, _currentPage),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              IndexedStack(
                index: _currentPage,
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
                child: MyDayAppBar(),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Future<bool> goBackToHomeOrExit(BuildContext context, int currentPage) {
    if (currentPage != 0) {
      context.read<CurrentRootPageNotifier>().changePage(0);
      return new Future<bool>.value(false);
    }
    return new Future<bool>.value(true);
  }
}
