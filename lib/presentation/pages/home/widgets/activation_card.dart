import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/service_notifier.dart';
import 'package:diary/presentation/pages/home/widgets/generic_card.dart';
import 'package:provider/provider.dart';
import '../../../widgets/generic_button.dart';

class ActivationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<ServiceState>(
      stateNotifier: context.watch<ServiceNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        final isEnabled = value.isEnabled;
        return Container(
          height: 240,
          child: GenericCard(
            icon: Icon(
              Icons.directions_walk,
              color: value.isEnabled ? Colors.green : Colors.red,
              size: 80,
            ),
            title: 'Tracciamento ${value.isEnabled ? 'A' : 'Ina'}ttivo',
            description:
                'Mantenere il tracciamento attivo per il buon funzionamento dell\'app.',
            bottomWidget: Align(
              alignment: Alignment.centerRight,
              child: GenericButton(
                onPressed: context.watch<ServiceNotifier>().invertEnabled,
                text: value.isEnabled ? 'DISATTIVA' : 'ATTIVA',
              ),
            ),
          ),
        );
      },
    );
  }
}
