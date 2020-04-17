import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/info_pin/info_pin_notifier.dart';
import 'package:diary/application/info_pin/info_pin_state.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InfoPinPageView extends StatefulWidget {
  final List<Location> locations;
  final Function selectPin;
  final Function onNoteAdded;
  final Function onNoteRemoved;
  final int initialPage;
  final PageController pageController;
  InfoPinPageView({
    Key key,
    this.locations,
    this.selectPin,
    this.initialPage,
    this.onNoteAdded,
    this.onNoteRemoved,
    this.pageController,
  }) : super(key: key);

  @override
  _InfoPinPageViewState createState() => _InfoPinPageViewState();
}

class _InfoPinPageViewState extends State<InfoPinPageView> {
  _InfoPinPageViewState();

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
    // todo work in progress for new interface!
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.locations.length,
      onPageChanged: (index) {
        context.read<CurrentIndexNotifier>().setPage(index);
        widget.selectPin(widget.locations[index]);
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        return InfoPinWidget(
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
    return Container(
      color: Theme.of(context).cardTheme.color,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Builder(builder: (
            context,
          ) {
            final String note =
                context.select<IndexState, String>((state) => state.note);
            if (note != null) {
              return Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.note)),
                  Expanded(
                      child: AutoSizeText(
                    note,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.body1,
                  )),
                ],
              );
            }
            return Container();
          }),
          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.data_usage)),
              Expanded(
                child: AutoSizeText(
                  widget.location.uuid,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.body1,
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
              Text(
                dateFormat.format(widget.location.dateTime),
                style: Theme.of(context).textTheme.body1,
              ),
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
                'Lat: ${widget.location.coords.latitude.toStringAsFixed(2)} Long: ${widget.location.coords.longitude.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.body1,
              ),
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
                'Accuratezza: ${widget.location.coords.accuracy} m',
                style: Theme.of(context).textTheme.body1,
              ),
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
                'Evento: ${widget.location.event.toString().replaceFirst('Event.', '')}',
                style: Theme.of(context).textTheme.body1,
              ),
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
                  'Attività: ${widget.location.activity.type.toUpperCase()} al ${widget.location.activity.confidence.toInt()} %',
                  style: Theme.of(context).textTheme.body1,
                ),
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
                Text(
                  '${(widget.location.battery.level * 100).toInt()} %',
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class InfoPinHeader extends StatelessWidget {
  final PageController pageController;

  const InfoPinHeader({Key key, @required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: StateNotifierBuilder<InfoPinState>(
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
        ),
      ),
    );
  }
}

class InfoPinInitialHeader extends StatelessWidget {
  final PageController pageController;

  const InfoPinInitialHeader({Key key, this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            final currentPage = context.read<IndexState>().index;
            if (currentPage > 0) {
              context.read<CurrentIndexNotifier>().goToPreviousPage();
              pageController.jumpToPage(currentPage - 1);
            }
          },
        ),
        Spacer(),
        Text(
            '${context.watch<IndexState>().index + 1} \\ ${context.read<CurrentIndexNotifier>().max}'),
        Spacer(),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            final currentPage = context.read<IndexState>().index;
            final max = context.read<CurrentIndexNotifier>().max;
            if (currentPage < max - 1) {
              context.read<CurrentIndexNotifier>().goToNextPage();
              pageController.jumpToPage(currentPage + 1);
            }
          },
        ),
      ],
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
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(
            'assets/annotated_pin.png',
            width: 30,
          ),
        ),
        Expanded(
          child: TextField(
            cursorColor: Theme.of(context).iconTheme.color,
            style: Theme.of(context).textTheme.body2,
            controller: textController,
            expands: false,
            minLines: 1,
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
                hintStyle: Theme.of(context).textTheme.body1.copyWith(
                      color: Color(0xFFC0CCDA),
                    ),
                hintText: 'Scrivi qui la tua nota'),
            onChanged: (t) {
              context.read<CurrentIndexNotifier>().tmpText = t;
            },
          ),
        ),
      ],
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
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: StateNotifierBuilder<InfoPinState>(
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
      ),
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
      return Row(
        children: <Widget>[
          Spacer(),
          GenericButton(
            text: 'Rimuovi Nota',
            color: Colors.red,
            onPressed: () async {
              final uuid =
                  await context.read<CurrentIndexNotifier>().removeNote();
              onNoteRemoved(uuid);
            },
          ),
          SizedBox(
            width: 10,
          ),
          GenericButton(
            text: 'Modifica Nota',
            color: null,
            onPressed: () async {
              context.read<InfoPinNotifier>().showEditing(note);
            },
          ),
        ],
      );
    }
    return GenericButton(
      text: 'Aggiungi Nota',
      color: null,
      onPressed: () async {
        context.read<InfoPinNotifier>().showEditing(null);
      },
    );
  }
}

class InfoPinEditingFooter extends StatelessWidget {
  final Function onNoteAdded;

  const InfoPinEditingFooter({Key key, this.onNoteAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Spacer(),
          GenericButton(
            text: 'Annulla',
            onPressed: () {
              context.read<InfoPinNotifier>().showInfo();
            },
          ),
          SizedBox(
            width: 5,
          ),
          GenericButton(
            text: 'Salva nota',
            color: Colors.green,
            onPressed: () async {
              final note =
                  await context.read<CurrentIndexNotifier>().saveNote();
              context.read<InfoPinNotifier>().showInfo();
              onNoteAdded(context.read<IndexState>().location.uuid, note);
            },
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
