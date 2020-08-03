import 'dart:io';

import 'package:diary/presentation/pages/add_annotation/add_annotation_page.dart';
import 'package:diary/presentation/pages/add_place/add_place_page.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';

/*
 * The main expandable FAB of the app, that brings possibility to add places
 * and annotations.
 */
class MainFabButton extends StatelessWidget {
  final double bottomPadding;
  final Function onMainButtonTap;
  final GlobalKey dialerKey;

  MainFabButton(
      {Key key, this.onMainButtonTap, this.dialerKey, this.bottomPadding});

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    // double buttonBottomPadding = 60.0 + MediaQuery.of(context).padding.bottom;
    // var mediaQueryData = MediaQuery.of(context);
    // if (_isIPhoneX(mediaQueryData)) {
    //   // fallback for all non iPhone X
    //   buttonBottomPadding += 30.0;
    // }
    logger.i('[MainFabButton] build');
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, Platform.isIOS ? 30 : 0.0),
      child: UnicornDialer(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
          key: dialerKey,
          onMainButtonPressed: onMainButtonTap,
          hasBackground: true,
          parentButtonBackground: Theme.of(context).accentColor,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: _buildMenuItems(context)),
    );
  }

  List<UnicornButton> _buildMenuItems(BuildContext context) {
    return <UnicornButton>[
      UnicornButton(
        hasLabel: true,
        labelText: "Aggiungi luogo",
        labelColor: Theme.of(context).textTheme.body2.color,
        labelShadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
        labelBackgroundColor: Theme.of(context).primaryColor,
        currentButton: FloatingActionButton(
          heroTag: "aggiungi luogo",
          // heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).iconTheme.color,
          mini: true,
          child: Icon(CustomIcons.map_marker_plus_outline),
          onPressed: () => _goToAddPlace(context),
        ),
      ),
      UnicornButton(
        hasLabel: true,
        labelText: "Aggiungi annotazione",
        labelColor: Theme.of(context).textTheme.body2.color,
        labelShadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
        labelBackgroundColor: Theme.of(context).primaryColor,
        currentButton: FloatingActionButton(
          heroTag: "aggiungi annotazione",
          // heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).iconTheme.color,
          mini: true,
          child: Icon(CustomIcons.bookmark_plus_outline),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AddAnnotationPage(),
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
