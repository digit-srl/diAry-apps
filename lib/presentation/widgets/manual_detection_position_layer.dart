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
            child: Center(
              child: Text(
                'Acquisizione Posizione...',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          )
        : Container();
  }
}
