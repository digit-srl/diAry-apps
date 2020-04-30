import 'package:diary/application/call_to_action/call_to_action_notifier.dart';
import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/presentation/widgets/info_stats_widget.dart';
import 'package:diary/utils/bottom_sheets.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
          'sullo smartphone) con le tracce locali. Solo se le tracce locali '
          'incrociano i luoghi e gli orari segnalati, le corrispondenti '
          '"Call to Action" vengono mostrate all\'utente.\n',
          style: Theme.of(context).textTheme.body1,
        ),
        Text(
          'PER ORA SI TRATTA SOLO DI SEGNALAZIONI DI PROVA SENZA ALCUNA '
          'RILEVANZA DAL PUNTO DI VISTA SANITARIO',
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16,
        ),
//        Padding(
//          padding: const EdgeInsets.all(10),
//          child: GenericButton(
//            text: 'Esegui',
//            onPressed: () => _performCallToAction(context),
//          ),
//        ),
        StateNotifierBuilder<CallToActionState>(
          stateNotifier: context.read<CallToActionNotifier>(),
          builder: (contest, state, child) {
            return state.map(
              initial: (_) {
                return Container();
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
    if (calls.isEmpty)
      return Container(
        height: 200,
        child: Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Non ci sono segnalazioni relative a luoghi che hai visitato',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
          ),
        ),
      );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: GenericButton(
            text: calls.isEmpty ? 'Esegui' : 'Aggiorna',
            onPressed: () => _performCallToAction(context),
          ),
        ),
        ...calls.map(
          (c) {
            return ActionCard(call: c);
          },
        ).toList()
      ],
    );
  }

  _performCallToAction(BuildContext context) {
    context.read<CallToActionNotifier>().performCall();
  }
}

class ActionCard extends StatelessWidget {
  final Call call;

  const ActionCard({Key key, this.call}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      closeOnScroll: true,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    call.description,
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.done_all,
                        color: (call.executed ?? false)
                            ? Colors.green
                            : Colors.grey,
                      ),
                      Icon(
                        Icons.remove_red_eye,
                        color:
                            (call.opened ?? false) ? Colors.blue : Colors.grey,
                      ),
                      Icon(
                        Icons.remove_circle,
                        color:
                            (call.archived ?? false) ? Colors.red : Colors.grey,
                      ),
                      Spacer(),
                      GenericButton(
                        text: 'Apri Url',
                        onPressed: () async {
                          if (!(call.opened ?? false)) {
                            await context
                                .read<CallToActionNotifier>()
                                .updateCall(call.copyWith(opened: true));
                            context.read<CallToActionNotifier>().loadCalls();
                          }

                          GenericUtils.launchURL(call.url);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        if (!(call.executed ?? false))
          MySlideAction(
            icon: Icons.done_all,
            color: Colors.green,
            caption: 'Eseguita?',
            onTap: () async {
              await context
                  .read<CallToActionNotifier>()
                  .updateCall(call.copyWith(executed: true));
              context.read<CallToActionNotifier>().loadCalls();
            },
          ),
      ],
      secondaryActions: <Widget>[
        if (!(call.archived ?? false))
          MySlideAction(
            icon: Icons.remove_circle,
            color: Colors.red,
            caption: 'Rimuovi',
            onTap: () async {
              await context
                  .read<CallToActionNotifier>()
                  .updateCall(call.copyWith(archived: true));
              context.read<CallToActionNotifier>().loadCalls();
            },
          ),
      ],
    );
  }
}

class MySlideAction extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final Color color;
  final String caption;

  const MySlideAction(
      {Key key, this.onTap, this.icon, this.color, this.caption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      color: Colors.transparent,
      child: Card(
        color: color,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: IconSlideAction(
          caption: caption,
          color: Colors.transparent,
          foregroundColor: Colors.white,
          icon: icon,
          onTap: onTap,
        ),
      ),
    );
  }
}
