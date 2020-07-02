import 'package:diary/utils/colors.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/service_notifier.dart';
import 'package:diary/presentation/pages/home/widgets/cards/home_generic_card.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/generic_button.dart';

/*
 * Home card that notifies the user about tracking actication state.
 */
class TrackingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<ServiceState>(
      stateNotifier: context.watch<ServiceNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        final isEnabled = value.isEnabled;
        return HomeGenericCard(
            iconData: CustomIcons.diary_logo,
            iconColor: accentColor,
            enabled: isEnabled,
            title: isEnabled ? 'Servizio attivo' : 'Servizio non attivo',
            description:
                "WOM diAry conserva i dati esclusivamnete sul tuo smartphone",
            bottomButtons: <Widget>[
              GenericButton(
                onPressed: context.watch<ServiceNotifier>().invertEnabled,
                text: isEnabled ? 'Disattiva' : 'Attiva',
              ),
            ]);
      },
    );
  }
}
