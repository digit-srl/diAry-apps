import 'dart:io';

import 'package:diary/application/info_pin/info_annotation_notifier.dart';
import 'package:diary/application/info_pin/info_annotation_state.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/presentation/pages/map/widgets/map_bottomsheets_utils.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class InfoAnnotation extends StatelessWidget {

  const InfoAnnotation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<InfoAnnotationState>(
      stateNotifier: context.read<InfoAnnotationNotifier>(),
      builder: (BuildContext context, state, Widget child) {
        return state.maybeMap(
            initial: (i) => InfoAnnotationInitial(),
            editing: (e) => InfoAnnotationEditing(),
            orElse: () => Container());
      },
    );
  }
}

class InfoAnnotationInitial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Annotation annotation = context.read<InfoAnnotationNotifier>().annotation;
    DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');

    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    //isHome ? CustomIcons.home_outline : CustomIcons.map_marker_outline,
                    CustomIcons.bookmark_outline,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  "Segnalazione", // annotation.title
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  context.read<InfoAnnotationNotifier>().showEditing();
                },
                tooltip: "Modifica",
              ),
              /*
            IconButton(
              icon: Icon(CustomIcons.trash_can_outline),
              tooltip: "Elimina",
              onPressed: () async {
                // todo
              },
            ),
            */
            ],
          ),
          SizedBox(
            height: 16,
          ),
          MapBottomsheetInfoBox(
            children: <Widget>[
              MapBottomsheetInfoLine(
                icon: Icon(Icons.message),
                text: annotation.title,
              ),
              MapBottomsheetInfoLine(
                icon: Icon(Icons.gps_fixed),
                text: 'Lat: ${annotation.latitude.toStringAsFixed(2)} '
                    'Long: ${annotation.longitude.toStringAsFixed(2)}',
              ),
              MapBottomsheetInfoLine(
                icon: Icon(Icons.access_time),
                text: dateFormat.format(annotation.dateTime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class InfoAnnotationEditing extends StatefulWidget {

  InfoAnnotationEditing({Key key}) : super(key: key);
  @override
  _InfoAnnotationEditingState createState() => _InfoAnnotationEditingState();
}

class _InfoAnnotationEditingState extends State<InfoAnnotationEditing> {
  TextEditingController textController;
  @override
  void initState() {
    super.initState();
    textController = TextEditingController(
        text: context.read<InfoAnnotationNotifier>().annotation.title);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon((Platform.isAndroid)
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios),
                onPressed: () {
                  context.read<InfoAnnotationNotifier>().showInfo();
                },
                tooltip: "Back",
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Modifica annotazione",
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  context
                      .read<InfoAnnotationNotifier>()
                      .saveNewAnnotationText();
                },
                tooltip: "Salva annotazione",
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: Container(
              decoration: new BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: new BorderRadius.all(Radius.circular(16))),
              child: TextField(
                cursorColor: Theme.of(context).iconTheme.color,
                style: Theme.of(context).textTheme.body2,
                controller: textController,
                expands: false,
                maxLines: 4,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    hintStyle: Theme.of(context).textTheme.body1,
                    hintText: 'Qui la tua segnalazione'),
                onChanged: (t) {
                  context.read<InfoAnnotationNotifier>().tmpText = t;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


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
