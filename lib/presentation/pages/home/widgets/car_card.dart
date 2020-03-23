import 'package:diary/domain/entities/motion_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/motion_activity_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:provider/provider.dart';
import 'generic_card.dart';

class CarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<MotionActivityState>(
      stateNotifier: context.watch<MotionActivityNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        if (value.activity == MotionActivity.InVehicle) {
          return Container(
            margin: const EdgeInsets.only(top: 16),
            child: GenericCard(
              enabled: false,
              iconData: Icons.directions_car,
              iconColor: Colors.black,
//              title: 'Ti stai muovendo con un veicolo',
              title:
                  value.activity.toString().replaceAll('MotionActivity.', ''),
              description:
                  'Ti consigliamo di annotare quale veicolo stai utilizzando.',
              bottomWidget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GenericButton(
                      text: 'AUTO PROPRIA',
                      withBorder: false,
                    ),
                  ),
                  Expanded(
                    child: GenericButton(
                      onPressed: () {},
                      text: 'ALTRO MEZZO',
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
