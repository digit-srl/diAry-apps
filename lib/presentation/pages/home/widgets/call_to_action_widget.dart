import 'package:diary/application/call_to_action/call_to_action_notifier.dart';
import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/presentation/widgets/info_stats_widget.dart';
import 'package:diary/utils/bottom_sheets.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

class CallToActionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StandardBottomSheetColumn(
      children: <Widget>[
        Text(
          'Call To Action',
          style: Theme.of(context).textTheme.headline,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Questo pulsante consulta il server per ricevere segnalazioni '
          'dall\'autorità sanitaria che verranno incrociate (direttamente '
          'sullo smartphone) con le tracce locali. Sono se le tracce locali '
          'incrociano i luoghi e gli orari segnalati, le corrispondenti '
          '"Call to Action" vengono mostrate all\'utente. '
          'PER ORA SI TRATTA SOLO DI SEGNALAZIONI DI PROVA SENZA ALCUNA '
          'RILEVANZA DAL PUNTO DI VISTA SANITARIO',
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          height: 16,
        ),
        StateNotifierBuilder<CallToActionState>(
          stateNotifier: context.read<CallToActionNotifier>(),
          builder: (contest, state, child) {
            return state.map(
              initial: (_) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GenericButton(
                    text: 'Esegui',
                    onPressed: () => _performCallToAction(context),
                  ),
                );
              },
              loading: (_) {
                return Container(
                  height: 200,
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              },
              error: (error) {
                return ErrorResponseWidget(error: error.message);
              },
              callResult: (res) => CallToActionResponseWidget(
                calls: res.calls,
              ),
            );
          },
        )
      ],
    );
  }

  _performCallToAction(BuildContext context) {
    context.read<CallToActionNotifier>().performCall();
  }
}

class CallToActionResponseWidget extends StatelessWidget {
  final List<Call> calls;

  const CallToActionResponseWidget({Key key, this.calls}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (calls.isEmpty) return Text('Nessuno dei tuoi punti r');

    return Column(
      children: calls.map((c) {
        return Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    c.description,
                    textAlign: TextAlign.start,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GenericButton(
                      text: 'Apri Url',
                      onPressed: () {
                        GenericUtils.launchURL(c.url);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),

      /* <Widget>[

        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            GenericButton(
              withBorder: false,
              text: 'Lo farò in seguito',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Spacer(),
            GenericButton(
              text: 'Apri il Pocket',
              onPressed: () {
                _launchURL(_dailyStatsResponse.womLink);
              },
            ),
          ],
        ),
      ],*/
    );
  }
}
