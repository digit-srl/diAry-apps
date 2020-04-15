import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class InfoPinPageView extends StatefulWidget {
  final List<Location> locations;
  final Function selectPin;
  final Function onNoteAdded;
  final Function onNoteRemoved;
  final int initialPage;

  InfoPinPageView({
    Key key,
    this.locations,
    this.selectPin,
    this.initialPage,
    this.onNoteAdded,
    this.onNoteRemoved,
  }) : super(key: key);

  @override
  _InfoPinPageViewState createState() => _InfoPinPageViewState();
}

class _InfoPinPageViewState extends State<InfoPinPageView> {
  PageController _pageController;

  _InfoPinPageViewState();

  Box box;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);

    box = Hive.box<String>('pinNotes');
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.locations.length,
      onPageChanged: (index) {
        widget.selectPin(widget.locations[index]);
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        return InfoPinWidget(
          index: itemIndex,
          location: widget.locations[itemIndex],
          note: box.get(widget.locations[itemIndex].uuid),
          onNoteAdded: widget.onNoteAdded,
          onNoteRemoved: widget.onNoteRemoved,
          onPrevious: () {
            //TODO change to animatedPage
            if (itemIndex > 0) {
              _pageController.jumpToPage(itemIndex - 1);
            }
          },
          onNext: () {
            //TODO change to animatedPage
            if (itemIndex < widget.locations.length - 1) {
              _pageController.jumpToPage(itemIndex + 1);
            }
          },
        );
      },
    );
  }
}

class InfoPinWidget extends StatefulWidget {
  final Function onNext;
  final Function onPrevious;
  final Function onNoteAdded;
  final Function onNoteRemoved;
  final Location location;
  final int index;
  final String note;

  const InfoPinWidget(
      {Key key,
      this.onNext,
      this.onPrevious,
      this.location,
      this.index,
      this.note,
      this.onNoteAdded,
      this.onNoteRemoved})
      : super(key: key);
  @override
  _InfoPinWidgetState createState() => _InfoPinWidgetState();
}

class _InfoPinWidgetState extends State<InfoPinWidget> {
  static DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');

  bool editingMode = false;
  TextEditingController textController;
  String get text => textController.text.trim();

  bool get isThereNote => text != null && text.isNotEmpty;
  FocusNode noteFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
//            mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          editingMode
              ? Container()
              : Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: widget.onPrevious,
                    ),
                    Spacer(),
                    Text((widget.index + 1).toString()),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      color: Colors.black,
                      onPressed: widget.onNext,
                    ),
                  ],
                ),
          editingMode
              ? Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.edit)),
                    Expanded(
                      child: Theme(
                        data: ThemeData(
                          primaryColor: accentColor,
                        ),
                        child: TextField(
                          autofocus: true,
                          controller: textController,
                          minLines: 1,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                )
              : isThereNote
                  ? Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.note)),
                        Expanded(
                            child: AutoSizeText(
                          text,
                          maxLines: 1,
                          style: TextStyle(fontSize: 30),
                        )),
                      ],
                    )
                  : Container(),
          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.data_usage)),
              Expanded(
                child: AutoSizeText(
                  widget.location.uuid,
                  maxLines: 1,
                  style: TextStyle(fontSize: 30),
                ),
              ),
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
              Text(dateFormat.format(widget.location.dateTime)),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.pin_drop,
                ),
              ),
              Text(
                  'Lat: ${widget.location.coords.latitude.toStringAsFixed(2)} Long: ${widget.location.coords.longitude.toStringAsFixed(2)}'),
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
              Text('Accuratezza: ${widget.location.coords.accuracy} m'),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.event,
                ),
              ),
              Text(
                  'Evento: ${widget.location.event.toString().replaceFirst('Event.', '')}'),
            ],
          ),
          if (widget.location?.activity != null)
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.directions_walk,
                  ),
                ),
                Text(
                    'Attività: ${widget.location.activity.type.toUpperCase()} al ${widget.location.activity.confidence.toInt()} %'),
              ],
            ),
          if (widget.location?.battery != null)
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    widget.location.battery.isCharging
                        ? Icons.battery_charging_full
                        : Icons.battery_std,
                  ),
                ),
                Text('${(widget.location.battery.level * 100).toInt()} %'),
              ],
            ),
          Row(
            children: <Widget>[
              Spacer(),
              isThereNote
                  ? GenericButton(
                      text: editingMode ? 'Annulla' : 'Elimina Nota',
                      color: editingMode ? null : Colors.red,
                      onPressed: () {
                        if (!editingMode) {
                          Hive.box<String>('pinNotes')
                              .delete(widget.location.uuid);
                          textController.clear();
                          widget.onNoteRemoved(widget.location.uuid);
                        } else {
                          editingMode = !editingMode;
                        }
                        setState(() {});
                      },
                    )
                  : editingMode
                      ? GenericButton(
                          text: 'Annulla',
                          color: null,
                          onPressed: () {
                            setState(() {
                              textController.clear();
                              editingMode = !editingMode;
                            });
                          },
                        )
                      : Container(),
              SizedBox(
                width: 5,
              ),
              GenericButton(
                text: editingMode
                    ? 'Salva nota'
                    : isThereNote ? 'Modifica Nota' : 'Aggiungi Nota',
                color: editingMode ? Colors.green : null,
                onPressed: () async {
                  if (editingMode && text.isNotEmpty) {
                    await Hive.box<String>('pinNotes')
                        .put(widget.location.uuid, text);
                    widget.onNoteAdded(widget.location.uuid, text);
                  }
                  setState(() {
                    editingMode = !editingMode;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//
//class InfoPinDetailsWidget extends StatelessWidget {
//  final int index;
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
////            mainAxisAlignment: MainAxisAlignment.end,
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.arrow_back),
//                color: Colors.black,
//                onPressed: onPrevious,
//              ),
//              Spacer(),
//              Text((index + 1).toString()),
//              Spacer(),
//              IconButton(
//                icon: Icon(Icons.arrow_forward),
//                color: Colors.black,
//                onPressed: onNext,
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                  padding: const EdgeInsets.all(8.0), child: Icon(Icons.note)),
//              Expanded(
//                  child: AutoSizeText(
//                text,
//                maxLines: 1,
//                style: TextStyle(fontSize: 30),
//              )),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Icon(Icons.data_usage)),
//              Expanded(
//                child: AutoSizeText(
//                  location.uuid,
//                  maxLines: 1,
//                  style: TextStyle(fontSize: 30),
//                ),
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Icon(
//                  Icons.timelapse,
//                ),
//              ),
//              Text(dateFormat.format(widget.location.dateTime)),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Icon(
//                  Icons.pin_drop,
//                ),
//              ),
//              Text(
//                  'Lat: ${location.coords.latitude.toStringAsFixed(2)} Long: ${location.coords.longitude.toStringAsFixed(2)}'),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Icon(
//                  Icons.gps_fixed,
//                ),
//              ),
//              Text('Accuratezza: ${location.coords.accuracy} m'),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Icon(
//                  Icons.event,
//                ),
//              ),
//              Text(
//                  'Evento: ${location.event.toString().replaceFirst('Event.', '')}'),
//            ],
//          ),
//          if (location?.activity != null)
//            Row(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Icon(
//                    Icons.directions_walk,
//                  ),
//                ),
//                Text(
//                    'Attività: ${location.activity.type.toUpperCase()} al ${location.activity.confidence.toInt()} %'),
//              ],
//            ),
//          if (location?.battery != null)
//            Row(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Icon(
//                    location.battery.isCharging
//                        ? Icons.battery_charging_full
//                        : Icons.battery_std,
//                  ),
//                ),
//                Text('${(location.battery.level * 100).toInt()} %'),
//              ],
//            ),
//          Row(
//            children: <Widget>[
//              Spacer(),
//              GenericButton(
//                text: editingMode ? 'Annulla' : 'Elimina',
//                color: editingMode ? null : Colors.red,
//                onPressed: () {
//                  if (!editingMode) {
//                    Hive.box<String>('pinNotes').delete(widget.location.uuid);
//                    textController.clear();
//                  }
//                  setState(() {});
//                },
//              ),
//              SizedBox(
//                width: 5,
//              ),
//              GenericButton(
//                text: editingMode
//                    ? 'Salva nota'
//                    : isThereNote ? 'Modifica Nota' : 'Aggiungi Nota',
//                color: editingMode ? Colors.green : null,
//                onPressed: () {
//                  if (editingMode && text.isNotEmpty) {
//                    Hive.box<String>('pinNotes')
//                        .put(widget.location.uuid, text);
//                  }
//                  setState(() {
//                    editingMode = !editingMode;
//                  });
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
//class InfoPinDeleteWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Text('delete'),
//    );
//  }
//}
//
//class InfoPinEditingWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Text('editing'),
//    );
//  }
//}
