import 'dart:io';

import 'package:diary/presentation/pages/add_annotation/add_annotation_page.dart';
import 'package:diary/presentation/pages/add_place/add_place_page.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

class MainFabButton extends StatelessWidget {
  final double bottomPadding;
  final Function onMainButtonTap;
  final GlobalKey dialerKey;

  MainFabButton(
      {Key key, this.onMainButtonTap, this.dialerKey, this.bottomPadding});

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
//    double buttonBottomPadding = 60.0 + MediaQuery.of(context).padding.bottom;
//    var mediaQueryData = MediaQuery.of(context);
//    if (_isIPhoneX(mediaQueryData)) {
//      // fallback for all non iPhone X
//      buttonBottomPadding += 30.0;
//    }
    print('MAIN MENU BUTTON BUILD');
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, Platform.isIOS ? 30 : 0.0),
      child: UnicornDialer(
          key: dialerKey,
          onMainButtonPressed: onMainButtonTap,
          hasBackground: true,
          parentButtonBackground: accentColor,
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
        labelColor: accentColor,
        currentButton: FloatingActionButton(
          heroTag: "aggiungi luogo",
//              heroTag: null,
          backgroundColor: bgColor,
          foregroundColor: accentColor,
          mini: true,
          child: Icon(Icons.add_location),
          onPressed: () => _goToAddPlace(context),
        ),
      ),
      UnicornButton(
        hasLabel: true,
        labelText: "Aggiungi segnalazione",
        labelColor: accentColor,
        currentButton: FloatingActionButton(
          heroTag: "aggiungi segnalazione",
//              heroTag: null,
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
          mini: true,
          child: Icon(Icons.bookmark_border),
          onPressed: () => _goToAddAnnotation(context),
        ),
      ),
    ];
  }

//  bool _isIPhoneX(MediaQueryData mediaQuery) {
//    if (defaultTargetPlatform == TargetPlatform.iOS) {
//      var size = mediaQuery.size;
//      if (size.height == 812.0 || size.width == 812.0) {
//        return true;
//      }
//    }
//    return false;
//  }

  void _goToAddAnnotation(context) {
//    final userRepo = Provider.of<UserRepositoryImpl>(context, listen: false);
//    final dateProvider = Provider.of<DayNotifier>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AddAnnotationPage(),
//            MultiProvider(
//          providers: [
//            Provider.value(
//              value: userRepo,
//            ),
//            Provider.value(
//              value: dateProvider,
//            ),
//          ],
//          child: AddAnnotationPage(),
//        ),
      ),
    );
  }

  _goToAddPlace(BuildContext context) {
//    final userRepo = Provider.of<UserRepositoryImpl>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AddPlacePage(),
        /* Provider.value(
          value: userRepo,
          child: AddPlacePage(),
        ),*/
      ),
    );
  }
}
