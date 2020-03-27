import 'package:diary/presentation/pages/slices_page.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/motion_activity_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:provider/provider.dart';
import 'generic_card.dart';

// import necessari pre funzionalità di debug aggiuntive e gps fittizio
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/service_notifier.dart';
import 'package:diary/domain/entities/motion_activity.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;

class BetaCard extends StatefulWidget {
  @override
  _BetaCardState createState() => _BetaCardState();
}

class _BetaCardState extends State<BetaCard> {
  bool isMoving = false;

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<MotionActivityState>(
      stateNotifier: context.watch<MotionActivityNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        return GenericCard(
          enabled: true,
          iconData: Icons.developer_mode,
          iconColor: accentColor,
          title: 'diAry v.0.0.5 Beta',
          description:
          'Scheda viene mostrata solo ai beta tester; contiene funzioni per il test.',
          bottomButtons: <Widget>[
            /*
            todo decommentare per aggiungere le funzionalità di debug e gps fittizio
            IconButton(
                icon: Icon(Icons.change_history),
                onPressed: () {
                  Provider.of<ServiceNotifier>(context, listen: false)
                      .invertEnabled();
                  Provider.of<LocationNotifier>(context, listen: false)
                      .addLocation(null);
                }),
            IconButton(
                color: isMoving ? Colors.green : Colors.red,
                icon: Icon(Icons.directions_walk),
                onPressed: () {
                  bg.BackgroundGeolocation.changePace(!isMoving);
                  setState(() {
                    isMoving = !isMoving;
                  });
                }),
            */
            GenericButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SlicesPage(),
                  ),
                );
              },
              text: 'Spicchi giornalieri',
            )
          ],
        );
      },
    );
  }
}