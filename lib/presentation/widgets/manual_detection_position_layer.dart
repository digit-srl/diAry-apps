import 'package:diary/application/gps_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManualDetectionPositionLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('[ManualDetectionPositionLayer] build');

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
                Container(
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
