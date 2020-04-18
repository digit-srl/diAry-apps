import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/info_pin/info_pin_state.dart';
import 'package:diary/application/info_pin/info_pin_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'map_bottomsheets_utils.dart';

class InfoAnnotationBody extends StatelessWidget {
  static DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');

  const InfoAnnotationBody({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Annotation annotation = context.read<InfoAnnotationNotifier>().annotation;

    return MapBottomsheetInfoBox(children: <Widget>[
      MapBottomsheetInfoLine(
        icon: Icon(Icons.gps_fixed),
        text:
            'Lat: ${annotation.latitude?.toStringAsFixed(2)} Long: ${annotation.longitude?.toStringAsFixed(2)}',
      ),
      MapBottomsheetInfoLine(
        icon: Icon(Icons.access_time),
        text: dateFormat.format(annotation.dateTime),
      ),
    ]);
  }
}

class InfoAnnotationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<InfoPinState>(
      stateNotifier: context.read<InfoAnnotationNotifier>(),
      builder: (BuildContext context, state, Widget child) {
        return state.maybeMap(
            initial: (i) => InfoAnnotationInitialHeader(),
            editing: (e) => InfoAnnotationEditingHeader(),
            orElse: () => Container());
      },
    );
  }
}

class InfoAnnotationInitialHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapBottomsheetHeader(
      child: Row(
        children: <Widget>[
          MapBottomsheetHeaderIcon(
            CustomIcons.bookmark_outline,
            color: Colors.amber
          ),
          SizedBox(width: 16),
          Expanded(
            child: AutoSizeText(
              context.read<InfoAnnotationNotifier>().annotation.title,
              maxLines: 3,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
      ])
    );
  }
}

class InfoAnnotationEditingHeader extends StatefulWidget {
  @override
  _InfoAnnotationEditingHeaderState createState() =>
      _InfoAnnotationEditingHeaderState();
}

class _InfoAnnotationEditingHeaderState
    extends State<InfoAnnotationEditingHeader> {
  TextEditingController textController;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(
        text: context.read<InfoAnnotationNotifier>().annotation.title);
  }

  @override
  Widget build(BuildContext context) {
    return MapBottomsheetHeader(
      child: Row(
        children: <Widget>[
          MapBottomsheetHeaderIcon(CustomIcons.bookmark_outline,
              color: Colors.amber),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              cursorColor: Theme.of(context).iconTheme.color,
              style: Theme.of(context).textTheme.body2,
              controller: textController,
              expands: false,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  hintStyle: Theme.of(context).textTheme.overline,
                  hintText: 'Qui la tua segnalazione'),
              onChanged: (t) {
                context.read<InfoAnnotationNotifier>().tmpText = t;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InfoAnnotationFooter extends StatelessWidget {
  const InfoAnnotationFooter({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<InfoPinState>(
        stateNotifier: context.read<InfoAnnotationNotifier>(),
        builder: (BuildContext context, state, Widget child) {
          return state.maybeMap(
              editing: (_) => InfoAnnotationEditingFooter(),
              initial: (e) => InfoAnnotationInitialFooter(),
              orElse: () => Container());
        });
  }
}

class InfoAnnotationInitialFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapBottomsheetFooter(buttons: <GenericButton>[
      GenericButton(
        text: 'Modifica',
        onPressed: () async {
          context.read<InfoAnnotationNotifier>().showEditing();
        },
      ),
    ]);
  }
}

class InfoAnnotationEditingFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapBottomsheetFooter(buttons: <GenericButton>[
      GenericButton(
        text: 'Annulla',
        withBorder: false,
        onPressed: () async {
          context.read<InfoAnnotationNotifier>().showInfo();
        },
      ),
      GenericButton(
        text: 'Salva',
        onPressed: () async {
          context.read<InfoAnnotationNotifier>().saveNewAnnotationText();
        },
      ),
    ]);
  }
}

/*
class InfoAnnotationError extends StatelessWidget {
  final String error;

  const InfoAnnotationError({Key key, this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
          Text(
            error,
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class InfoAnnotationEditing extends StatefulWidget {
  final String text;

  InfoAnnotationEditing({Key key, @required this.text}) : super(key: key);
  @override
  _InfoAnnotationEditingState createState() => _InfoAnnotationEditingState();
}

class _InfoAnnotationEditingState extends State<InfoAnnotationEditing> {
  TextEditingController textController;
  @override
  void initState() {
    super.initState();
    this.textController = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Text(
            '${widget.text.isEmpty ? 'Aggiungi' : 'Modifica'}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          TextField(
            style: Theme.of(context).textTheme.body2,
            controller: textController,
            minLines: 1,
            maxLines: 2,
          ),
//          Spacer(),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              GenericButton(
//                text: 'Annulla',
//                onPressed: () async {
//                  context.read<InfoAnnotationNotifier>().showInfo();
//                },
//              ),
//              SizedBox(
//                width: 10,
//              ),
//              GenericButton(
//                text: 'Salva',
//                color: Colors.green,
//                onPressed: () async {
//                  context
//                      .read<InfoAnnotationNotifier>()
//                      .saveNewAnnotationText(textController.text.trim());
//                },
//              ),
//            ],
//          ),
        ],
      ),
    );
  }
}
*/

/*class InfoAnnotation extends StatelessWidget {
  final Annotation annotation;

  const InfoAnnotation({Key key, this.annotation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/annotation_pin.png',
                    width: 30,
                  )),
              editingMode
                  ? Expanded(
                      child: TextField(
                        controller: titleController,
                        maxLines: 2,
                        minLines: 1,
                      ),
                    )
                  : Expanded(
                      child: AutoSizeText(
                        annotation.title,
                        maxLines: 3,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
//                    coloredGeofence.isHome
//                        ? Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Icon(
//                              Icons.person_pin,
//                              size: 35,
//                              color: color,
//                            ),
//                          )
//                        : Container(),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.gps_fixed,
                ),
              ),
              Text(
                  'Lat: ${annotation.latitude?.toStringAsFixed(2)} Long: ${annotation.longitude?.toStringAsFixed(2)}'),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.timelapse,
                ),
              ),
              Text(dateFormat.format(annotation.dateTime)),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: <Widget>[
                Spacer(),
                GenericButton(
                  text: editingMode ? 'Annulla' : 'Elimina',
                  color: editingMode ? null : Colors.red,
                  onPressed: () async {
                    if (editingMode) {
                      setState(() {
                        editingMode = !editingMode;
                      });
                    } else {
                      GenericUtils.ask(context,
                          'Sicuro di volere eliminare questa annotazione?', () {
                        context
                            .read<AnnotationNotifier>()
                            .removeAnnotation(annotation);
                        Navigator.of(context).pop();
                      }, () {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                GenericButton(
                  text: editingMode ? 'Salva' : 'Modifica',
                  color: editingMode ? Colors.green : null,
                  onPressed: () async {
                    if (editingMode) {
                      annotation.title = titleController.text.trim();
                      await annotation.save();
                    }
                    setState(() {
                      editingMode = !editingMode;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

//class InfoAnnotationDeletingQuestion extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      height: 200,
//      padding: const EdgeInsets.all(8),
//      child: Column(
//        children: <Widget>[
//          Spacer(),
//          Text(
//            'Sicuro di volere eliminare questa annotazione?',
//            style: Theme.of(context).textTheme.title,
//            textAlign: TextAlign.center,
//          ),
//          Spacer(),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              GenericButton(
//                text: 'Annulla',
//                onPressed: () async {
//                  context.read<InfoAnnotationNotifier>().showInfo();
//                },
//              ),
//              SizedBox(
//                width: 10,
//              ),
//              GenericButton(
//                text: 'Si',
//                onPressed: () async {
//                  context.read<InfoAnnotationNotifier>().deleteAnnotation();
//                },
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//class InfoAnnotationDeletingComplete extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      height: 200,
//      padding: const EdgeInsets.all(8),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        children: <Widget>[
//          Icon(
//            Icons.check_circle,
//            color: Colors.green,
//            size: 50,
//          ),
//          Text(
//            'Eliminazione completata',
//            style: Theme.of(context).textTheme.title,
//            textAlign: TextAlign.center,
//          ),
//        ],
//      ),
//    );
//  }
//}

/*class InfoAnnotationWidget extends StatefulWidget {
  final Annotation annotation;

  const InfoAnnotationWidget({Key key, this.annotation}) : super(key: key);
  @override
  _InfoAnnotationWidgetState createState() => _InfoAnnotationWidgetState();
}

class _InfoAnnotationWidgetState extends State<InfoAnnotationWidget> {
  Annotation get annotation => widget.annotation;
//  DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');
  bool editingMode = false;
  TextEditingController titleController;
  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: annotation.title);
  }

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder(
      stateNotifier: context.read<InfoAnnotationNotifier>(),
      builder: (BuildContext context, InfoAnnotationState state, Widget child) {
        return state.map(
          initial: (s) => InfoAnnotation(annotation: s.annotation),
          loading: (_) => Center(
            child: CircularProgressIndicator(),
          ),
          deleting: (s) => InfoAnnotationDeletingQuestion(),
          deleteComplete: (s) => InfoAnnotationDeletingComplete(),
          error: (Error value) => InfoAnnotationError(),
          editing: (Editing value) => InfoAnnotationEditing(
            text: value.text,
          ),
        );
      },
    );
  }
}*/
