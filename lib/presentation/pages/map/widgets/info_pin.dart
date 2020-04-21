import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/info_pin/info_pin_notifier.dart';
import 'package:diary/application/info_pin/info_pin_state.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'map_bottomsheets_utils.dart';

class InfoPinBody extends StatefulWidget {
  final List<Location> locations;
  final Function selectPin;
  final Function onNoteAdded;
  final Function onNoteRemoved;
  final int initialPage;
  final PageController pageController;
  InfoPinBody({
    Key key,
    this.locations,
    this.selectPin,
    this.initialPage,
    this.onNoteAdded,
    this.onNoteRemoved,
    this.pageController,
  }) : super(key: key);

  @override
  _InfoPinBodyState createState() => _InfoPinBodyState();
}

class _InfoPinBodyState extends State<InfoPinBody> {
  _InfoPinBodyState();

  Box box;
  PageController get _pageController => widget.pageController;

  @override
  void initState() {
    super.initState();
//    _pageController = PageController(initialPage: widget.initialPage);

    box = Hive.box<String>('pinNotes');
  }

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<InfoPinState>(
      stateNotifier: context.read<InfoPinNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        return value.maybeMap(
            initial: (_) => Container(
                  height: 322,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.locations.length,
                    onPageChanged: (index) {
                      context.read<CurrentIndexNotifier>().setPage(index);
                      widget.selectPin(widget.locations[index]);
                    },
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return InfoPinBodyPage(
                        index: itemIndex,
                        location: widget.locations[itemIndex],
                        note: context.read<IndexState>().note,
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
                  ),
                ),
            editing: (editing) => MapBottomsheetEmptyBody(),
            orElse: () => MapBottomsheetEmptyBody());
      },
    );
  }
}

class InfoPinBodyPage extends StatelessWidget {
  final Function onNext;
  final Function onPrevious;
  final Function onNoteAdded;
  final Function onNoteRemoved;
  final Location location;
  final int index;
  final String note;
  static DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');

  const InfoPinBodyPage(
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
  Widget build(BuildContext context) {
    return MapBottomsheetInfoBox(children: <Widget>[
      MapBottomsheetFixedInfoLine(
        icon: Icon(Icons.note),
        text: context.select<IndexState, String>((state) => state.note) ??
            "Nessuna nota",
      ),
      MapBottomsheetFixedInfoLine(
        icon: Icon(Icons.data_usage),
        text: location.uuid,
      ),
      MapBottomsheetFixedInfoLine(
        icon: Icon(Icons.timelapse),
        text: dateFormat.format(location.dateTime),
      ),
      MapBottomsheetFixedInfoLine(
        icon: Icon(Icons.pin_drop),
        text:
            'Lat: ${location.coords.latitude.toStringAsFixed(2)} Long: ${location.coords.longitude.toStringAsFixed(2)}',
      ),
      MapBottomsheetFixedInfoLine(
        icon: Icon(Icons.gps_fixed),
        text: 'Accuratezza: ${location.coords.accuracy} metri',
      ),
      MapBottomsheetFixedInfoLine(
        icon: Icon(Icons.event),
        text: 'Evento: ${location.event.toString().replaceFirst('Event.', '')}',
      ),
      MapBottomsheetFixedInfoLine(
        icon: Icon(Icons.directions_walk),
        text:
            'Attività: ${location.activity.type.toUpperCase()} al ${location.activity.confidence.toInt()} %',
      ),
      MapBottomsheetFixedInfoLine(
        icon: Icon(
          location.battery.isCharging
              ? Icons.battery_charging_full
              : Icons.battery_std,
        ),
        text: '${(location.battery.level * 100).toInt()} %',
      ),
    ]);
  }
}

class InfoPinHeader extends StatelessWidget {
  final PageController pageController;

  const InfoPinHeader({Key key, @required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<InfoPinState>(
      stateNotifier: context.read<InfoPinNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        return value.maybeMap(
            initial: (_) => InfoPinInitialHeader(
                  pageController: pageController,
                ),
            editing: (editing) => InfoPinEditingHeader(
                  text: editing.text,
                ),
            orElse: () => Container());
      },
    );
  }
}

class InfoPinInitialHeader extends StatelessWidget {
  final PageController pageController;

  const InfoPinInitialHeader({Key key, this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String note =
        context.select<IndexState, String>((state) => state.note);

    return MapBottomsheetHeader(
      horizontalPadding: 12,
      child: Row(children: <Widget>[
        IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            final currentPage = context.read<IndexState>().index;
            if (currentPage > 0) {
              context.read<CurrentIndexNotifier>().goToPreviousPage();
              pageController.jumpToPage(currentPage - 1);
            }
          },
        ),
        MapBottomsheetHeaderIcon(
            (note != null)
                ? CustomIcons.bookmark_outline
                : CustomIcons.pin_outline,
            color: Colors.blue),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: AutoSizeText(
            "Pin",
            maxLines: 1,
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Text(
          '${context.watch<IndexState>().index + 1}\\${context.read<CurrentIndexNotifier>().max}',
          style: Theme.of(context).textTheme.headline,
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_right),
          onPressed: () {
            final currentPage = context.read<IndexState>().index;
            final max = context.read<CurrentIndexNotifier>().max;
            if (currentPage < max - 1) {
              context.read<CurrentIndexNotifier>().goToNextPage();
              pageController.jumpToPage(currentPage + 1);
            }
          },
        ),
      ]),
    );
  }
}

class InfoPinEditingHeader extends StatefulWidget {
  final String text;

  const InfoPinEditingHeader({Key key, this.text}) : super(key: key);

  @override
  _InfoPinEditingHeaderState createState() => _InfoPinEditingHeaderState();
}

class _InfoPinEditingHeaderState extends State<InfoPinEditingHeader> {
  TextEditingController textController;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return MapBottomsheetHeader(
      child: Row(
        children: <Widget>[
          MapBottomsheetHeaderIcon(CustomIcons.bookmark_outline,
              color: Colors.blue),
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
                  hintText: 'Scrivi qui la nota da allegare'),
              onChanged: (t) {
                context.read<CurrentIndexNotifier>().tmpText = t;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InfoPinFooter extends StatelessWidget {
  final Function onNoteAdded;
  final Function onNoteRemoved;

  const InfoPinFooter({Key key, this.onNoteAdded, this.onNoteRemoved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<InfoPinState>(
      stateNotifier: context.read<InfoPinNotifier>(),
      builder: (context, state, child) {
        return state.maybeMap(
            initial: (_) => InfoPinInitialFooter(
                  onNoteRemoved: onNoteRemoved,
                ),
            editing: (_) => InfoPinEditingFooter(
                  onNoteAdded: onNoteAdded,
                ),
            orElse: () => Container());
      },
    );
  }
}

class InfoPinInitialFooter extends StatelessWidget {
  final Function onNoteRemoved;

  const InfoPinInitialFooter({Key key, @required this.onNoteRemoved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String note =
        context.select<IndexState, String>((state) => state.note);

    if (note != null) {
      return MapBottomsheetFooter(
          showExpandButton: true,
          buttons: <GenericButton>[
            GenericButton(
              text: 'Modifica nota',
              withBorder: false,
              onPressed: () async {
                SheetController.of(context).collapse();
                context.read<InfoPinNotifier>().showEditing(note);
              },
            ),
            GenericButton(
              text: 'Rimuovi nota',
              onPressed: () async {
                final uuid =
                    await context.read<CurrentIndexNotifier>().removeNote();
                onNoteRemoved(uuid);
              },
            ),
          ]);
    } else {
      return MapBottomsheetFooter(buttons: <GenericButton>[
        GenericButton(
          text: 'Aggiungi Nota',
          color: null,
          onPressed: () async {
            SheetController.of(context).collapse();
            context.read<InfoPinNotifier>().showEditing(null);
          },
        )
      ]);
    }
  }
}

class InfoPinEditingFooter extends StatelessWidget {
  final Function onNoteAdded;

  const InfoPinEditingFooter({Key key, this.onNoteAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapBottomsheetFooter(
        showExpandButton: false,
        buttons: <GenericButton>[
          GenericButton(
            text: 'Annulla',
            withBorder: false,
            onPressed: () async {
              context.read<InfoPinNotifier>().showInfo();
            },
          ),
          GenericButton(
            text: 'Salva nota',
            onPressed: () async {
              final note =
                  await context.read<CurrentIndexNotifier>().saveNote();
              context.read<InfoPinNotifier>().showInfo();
              onNoteAdded(context.read<IndexState>().location.uuid, note);
            },
          ),
        ]);
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
