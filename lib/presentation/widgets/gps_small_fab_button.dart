import 'package:diary/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
 * A small fab displayed inside add pages, used to trigger GPS action.
 */
class GpsSmallFabButton extends StatelessWidget {
  final Function onPressed;

  const GpsSmallFabButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    logger.i('[GpsSmallFabButton] build');

    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.gps_fixed),
          iconSize: 16,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
