import 'package:diary/domain/entities/motion_activity.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/motion_activity_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:provider/provider.dart';
import 'generic_card.dart';

class WomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<MotionActivityState>(
      stateNotifier: context.watch<MotionActivityNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        //if (value.activity == MotionActivity.InVehicle) {
        return GenericCard(
          enabled: true,
          iconData: Icons.favorite_border,
          iconColor: accentColor,
//              title: 'Ti stai muovendo con un veicolo',
          title: "Ottieni xx WOM",
          description:
              'Condividere i tuoi dati ci permette di incrociarli con gli altri.',
          bottomButtons: <Widget>[

            GenericButton(
              onPressed: () {},
              withBorder: false,
              text: 'Cosa sono i WOM?',
            ),
            GenericButton(
              onPressed: () {},
              text: 'Carica dati',
            ),
          ],
        );
        //}
        return Container();
      },
    );
  }
}
