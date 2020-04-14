import 'package:flutter/material.dart';

/*
 * An overlay container displayed over the map, that becomes active when an
 * error is detected, usually during GPS detection. The fact that an error is
 * detected is passed from the outside of the widget, using the relative
 * parameter.
 */
class DetectionErrorPositionLayer extends StatelessWidget {
  bool errorDetected;

  DetectionErrorPositionLayer([this.errorDetected]);

  @override
  Widget build(BuildContext context) {
    print('[DetectionErrorPositionLayer] build');

    return errorDetected
        ? Container(
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.gps_off,
                  color: Colors.white,
                  size: 40,
                ),
                Container(
                  height: 16,
                ),
                Text(
                  'Posizione non rilevata. Attiva i servizi GPS e riprova.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          )

        : Container();
  }
}
