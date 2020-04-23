import 'package:diary/application/gps_notifier.dart';
import 'package:diary/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
 * An overlay container displayed over the map during GPS position detection.
 */
class ManualDetectionPositionLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.i('[ManualDetectionPositionLayer] build');

    return context.watch<GpsState>().manualPositionDetection
        ? Container(
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Acquisendo la tua posizione corrente...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          )
        : Container();
  }
}
