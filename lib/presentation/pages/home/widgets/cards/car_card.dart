import 'package:diary/domain/entities/motion_activity.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/motion_activity_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:provider/provider.dart';
import 'home_generic_card.dart';

class CarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<MotionActivityState>(
      stateNotifier: context.watch<MotionActivityNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        //if (value.activity == MotionActivity.InVehicle) {
          return HomeGenericCard(
              enabled: true,
              iconData: Icons.directions_car,
//              title: 'Ti stai muovendo con un veicolo',
              title:
                  value.activity.toString().replaceAll('MotionActivity.', ''),
              description:
                  'Ti consigliamo di annotare quale veicolo stai utilizzando.',
              bottomButtons: <Widget>[
                    GenericButton(
                      onPressed: () {},
                      text: 'Auto propria',
                      withBorder: false,
                    ),

                GenericButton(
                      onPressed: () {},
                      text: 'Altro mezzo',
                    ),
                ],
            );
        //}
        return Container();
      },
    );
  }
}
