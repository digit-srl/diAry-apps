import 'package:diary/application/gps_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetectionErrorPositionLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('[DetectionErrorPositionLayer] build');

    return Container(
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
                  'Errore nel rilevamento della tua posizione. Attiva i servizi GPS, se disattivati.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          );

  }
}
