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
//        if (value.activity == MotionActivity.InVehicle) {
        return Container(
          height: 240,
          margin: const EdgeInsets.only(top: 16),
          child: GenericCard(
            icon: Icon(
              Icons.directions_car,
              color: Colors.black,
              size: 80,
            ),
//              title: 'Ti stai muovendo con un veicolo',
            title: value.activity.toString().replaceAll('MotionActivity.', ''),
            description: 'Ci servirebbe sapere quale veicolo stai utilizzando',
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
//        }
//        return Container();
      },
    );
  }
}
