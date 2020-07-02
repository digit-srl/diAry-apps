import 'package:diary/application/gps_notifier.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'home_generic_card.dart';

/*
 * Card shown only if GPS is disabled.
 */
class GpsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<GpsState>(
      stateNotifier: context.watch<GpsNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        if (!value.gpsEnabled) {
          return HomeGenericCard(
            enabled: value.gpsEnabled,
            iconData: Icons.gps_off,
            iconColor: accentColor,
            title: 'GPS non attivo',
            description:
                'Mantieni il GPS attivo per il corretto funzionamento dell\'applicazione.',
            bottomButtons: null,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
