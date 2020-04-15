import 'package:diary/application/current_root_page_notifier.dart';
import 'package:diary/presentation/pages/annotations/annotations_page.dart';
import 'package:diary/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:diary/presentation/pages/home/home_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:diary/presentation/widgets/main_app_bar.dart';

import '../map/map_page.dart';

/*
 * It keeps main pages and the custom appBar in a stack. It also handles
 * click on Android back button, aligning it to Android standards, and it
 * initializes style overlay elements.
 */
class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    int _currentPage = context.watch<CurrentRootPageState>().currentPage;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // sets style of overlay elements (such as navigation bar
      // or status bar) adapting it to day or night mode
      value: AppTheme.systemOverlayStyle(context),

      child: WillPopScope(
        onWillPop: () => handleBackButtonPress(context, _currentPage),
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            top: false,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[

                // the indexed stack contains the main screens,
                // keeping them alive and synchronized
                IndexedStack(
                  index: _currentPage,
                  children: <Widget>[
                    HomePage(),
                    MapPage(),
                    AnnotationsPage(),
                  ],
                ),

                // it contains the custom appBar
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: MainAppBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // It executes a Navigation.pop() when back button is clicked from map or
  // annotation page, meanwhile it exits app when in home page
  // todo should also handle custom fab button closing, some problems here
  Future<bool> handleBackButtonPress(BuildContext context, int currentPage) {
    final notInHomeScreen = currentPage != 0;

    // todo problems configuring dialerkey WillPop scope!
    // final isFabOpen = !dialerKey.currentState.close();
    // if (isFabOpen) {
    //   return new Future<bool>.value(true);
    // } else if ...

    if (notInHomeScreen) {
      context.read<CurrentRootPageNotifier>().changePage(0);
      return Future.value(false);
    } else {
      return new Future.value(true);
    }
  }
}
