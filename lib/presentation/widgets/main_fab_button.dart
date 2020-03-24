import 'package:diary/infrastructure/user_repository.dart';
import 'package:diary/presentation/pages/add_place/add_place_page.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:provider/provider.dart';

class MainMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double buttonBottomPadding = 60.0 - 32;
    var mediaQueryData = MediaQuery.of(context);
    if (_isIPhoneX(mediaQueryData)) {
      // fallback for all non iPhone X
      buttonBottomPadding += 30.0;
    }
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
        labelColor: accentColor,
        currentButton: FloatingActionButton(
          heroTag: "aggiungi luogo",
//              heroTag: null,
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
          mini: true,
          child: Icon(Icons.add_location),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Provider.value(
                    value:
                        Provider.of<UserRepositoryImpl>(context, listen: false),
                    child: AddPlacePage()),
              ),
            );
          },
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
