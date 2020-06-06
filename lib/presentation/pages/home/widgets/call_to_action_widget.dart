import 'package:diary/application/call_to_action/call_to_action_notifier.dart';
import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/domain/entities/call_to_action_source.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/presentation/widgets/info_stats_widget.dart';
import 'package:diary/utils/alerts.dart';
import 'package:diary/utils/bottom_sheets.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
          'Premendo nel pulsante sottostante, diAry consulterà il proprio server, '
          'per verifiare se sono presenti Call To Action. Queste verranno '
          'incrociate, direttamente sullo smartphone, con le tracce memorizzate '
          'in locale. L\'operazione è basata su orario e luogo della '
          'segnalazione: se ha esito positivo, le Call To Action verranno '
          'mostrate nel box sottostante.\n',
          style: Theme.of(context).textTheme.body1,
        ),
        Text(
          'Le segnalazioni di rilevanza sanitaria sono evidenziate '
          'con un cerchio di colore rosso nel titolo.',
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
                return ErrorResponseWidget(
                  error:
                      'Si è verificato un errore, sicuro di essere connesso ad internet?',
                );
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
}

class CallToActionResponseWidget extends StatelessWidget {
  final List<Call> calls;

  const CallToActionResponseWidget({Key key, this.calls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (calls.isEmpty)
      return Column(
        children: <Widget>[
          Container(
            height: 200,
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
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
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GenericButton(
              text: calls.isEmpty ? 'Esegui' : 'Aggiorna',
              onPressed: () => _performCallToAction(context),
            ),
          ),
        ],
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
                  if (call.sourceName != null && call.sourceName.isNotEmpty)
                    Text(
                      call.sourceName,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  Text(
                    call.description,
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.done_all,
                          color: (call.executed ?? false)
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.remove_red_eye,
                          color: (call.opened ?? false)
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      if (call.maxTime != null && call.maxTime > 0)
                        Text('${call.maxTime} sec'),
//                      Icon(
//                        Icons.remove_circle,
//                        color:
//                            (call.archived ?? false) ? Colors.red : Colors.grey,
//                      ),
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
              // it is used a dialog without standard buttons: the buttons are
              // inserted as content, to show them vertically
              Alerts.showAlertWithContentAndNoButtons(
                context,
                'Rimuovi Call To Action',
                "Sei sicuro di voler rimuovere questa Call to Action dalla lista?",
                Column(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    DialogButton(
                        radius: BorderRadius.circular(10.0),
                        child: Text(
                          "Annulla",
                          style: Theme.of(context).textTheme.button.copyWith(
                              color: Theme.of(context).textTheme.body2.color),
                        ),
                        color: Colors.transparent,
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    SizedBox(
                      height: 8,
                    ),
                    DialogButton(
                      radius: BorderRadius.circular(10.0),
                      child: Text(
                        "Sì, rimuovi",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.button,
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () async {
                        await context
                            .read<CallToActionNotifier>()
                            .deleteCall(call.copyWith(archived: true));
                        context.read<CallToActionNotifier>().loadCalls();
                        Navigator.of(context).pop();
                      },
                    ),
                    if (call.source != null && call.source.isNotEmpty)
                      SizedBox(
                        height: 8,
                      ),
                    if (call.source != null && call.source.isNotEmpty)
                      DialogButton(
                        radius: BorderRadius.circular(10.0),
                        height: 60,
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Text(
                              "Sì, e non riceverne più dalla fonte " +
                                  call.sourceName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.button),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          await Hive.box<CallToActionSource>('blackList')
                              .add(CallToActionSource(
                            call.source,
                            call.sourceName,
                            call.sourceDesc,
                          ));
                          await context
                              .read<CallToActionNotifier>()
                              .deleteCall(call.copyWith(archived: true));
                          context.read<CallToActionNotifier>().loadCalls();
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              );
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
