import 'package:diary/domain/entities/motion_activity.dart';
import 'package:diary/presentation/pages/slices_page.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/motion_activity_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:provider/provider.dart';
import 'generic_card.dart';

class BetaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<MotionActivityState>(
      stateNotifier: context.watch<MotionActivityNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        //if (value.activity == MotionActivity.InVehicle) {
        return GenericCard(
          enabled: true,
          iconData: Icons.developer_mode,
          iconColor: accentColor,
          title: 'diAry v.0.0.5',
          description:
              'Scheda viene mostrata solo ai beta tester; contiene funzioni per il test.',
          bottomButtons: <Widget>[
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
            ),
          ],
        );
        //}
        return Container();
      },
    );
  }
}
