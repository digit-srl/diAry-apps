import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

class MainMenuButton extends StatelessWidget {
  BuildContext _context;

//  void _onClickMenu() async {
//    // Text a backgroundTask on menu-click.
//    bg.BackgroundGeolocation.startBackgroundTask().then((int taskId) {
//      print("********* startBackgroundTask: $taskId");
//
//      // Simulate a long-running async task.
//      new Timer(Duration(milliseconds: 250), () {
//        bg.BackgroundGeolocation.finish(taskId);
//      });
//
//    });
//  }
//
//  void _onClickSettings() {
//    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
//    Navigator.of(_context).push(MaterialPageRoute<Null>(fullscreenDialog: true, builder: (BuildContext context) {
//      return SettingsView();
//    }));
//  }
//
//  void _onClickResetOdometer() {
//    bg.BackgroundGeolocation.setOdometer(0.0);
//  }
//
//  void _onClickEmailLog() async {
//    actions.Actions.emailLog(_context);
//  }
//
//  void _onClickSync() async {
//    actions.Actions.sync(_context);
//  }
//
//  void _onClickDestroyLocations() async {
//    actions.Actions.destroyLocations(_context);
//  }

  @override
  Widget build(BuildContext context) {
    double buttonBottomPadding = 60.0 - 32;
    var mediaQueryData = MediaQuery.of(context);
    if (_isIPhoneX(mediaQueryData)) {
      // fallback for all non iPhone X
      buttonBottomPadding += 30.0;
    }

    _context = context;
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, buttonBottomPadding),
      child: UnicornDialer(
//          onMainButtonPressed: _onClickMenu,
          hasBackground: false,
          parentButtonBackground: Colors.black,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add, color: Colors.black),
          childButtons: _buildMenuItems(context)),
    );
  }

  List<UnicornButton> _buildMenuItems(BuildContext context) {
    Color bgColor = Theme.of(context).bottomAppBarColor;

    return <UnicornButton>[
      UnicornButton(
          hasLabel: true,
          labelText: "Aggiungi luogo",
          currentButton: FloatingActionButton(
              heroTag: "aggiungi luogo",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.add_location),
              onPressed: () {})),
      UnicornButton(
          hasLabel: true,
          labelText: "Aggiungi segnalazione",
          currentButton: FloatingActionButton(
              heroTag: "aggiungi segnalazione",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.bookmark_border),
              onPressed: () {})),
    ];
  }

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      var size = mediaQuery.size;
      if (size.height == 812.0 || size.width == 812.0) {
        return true;
      }
    }
    return false;
  }
}
