import 'package:diary/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/utils/extensions.dart';
import 'package:provider/provider.dart';

class GpsSmallFabButton  extends StatelessWidget {
  final Function onPressed;

  const GpsSmallFabButton({ this.onPressed });
  
  @override
  Widget build(BuildContext context) {
    print('[GpsSmallFabButton] build');

    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.gps_fixed),
          iconSize: 16,
          color: accentColor,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
