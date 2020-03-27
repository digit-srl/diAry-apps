import 'package:diary/application/gps_notifier.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'generic_card.dart';

class GpsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<GpsState>(
      stateNotifier: context.watch<GpsNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        if (!value.gpsEnabled) {
          return GenericCard(
              enabled: value.gpsEnabled,
              iconData: Icons.gps_off,
              iconColor: accentColor,
              title: 'GPS non attivo',
              description:
                  'Senza GPS, non può essere effettuato il tracciamento',
              bottomButtons: null,
            );
        } else {
          return Container();
        }
      },
    );
  }
}
