import 'package:diary/application/date_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/root/date_notifier.dart';
import 'package:diary/presentation/widgets/calendar_button.dart';
import 'package:diary/presentation/widgets/main_fab_button.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:diary/utils/extensions.dart';

class AnnotationsPage extends StatefulWidget {
  @override
  _AnnotationsPageState createState() => _AnnotationsPageState();
}

class _AnnotationsPageState extends State<AnnotationsPage> {
  DateFormat format = DateFormat('HH : mm');

  final double targetElevation = 4;
  double _elevation = 0;
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    double newElevation = _controller.offset > 1 ? targetElevation : 0;
    if (_elevation != newElevation) {
      setState(() {
        _elevation = newElevation;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: accentColor
        ),
        elevation: _elevation,
        title: CalendarButton(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){},
            tooltip: "Cerca segnalazione",
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: MainFabButton(),
      body: StateNotifierBuilder<DateState>(
          stateNotifier: context.watch<DateNotifier>(),
          builder: (BuildContext context, dateState, Widget child) {
/*           final day =
            Provider.of<LocationNotifier>(context, listen: false).getDay();


            if (day.annotations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.bookmark_border,
                      color: accentColor,
                      size: 40,
                    ),
                    Text('Nessuna annotazione'),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding:  EdgeInsets.all(8),
              controller: _controller,
              itemCount: day.annotations.length,
              itemBuilder: (context, index) {
                final annotation = day.annotations[index];
                return ListTile(
                    title: Text(
                      annotation.title,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    leading: Icon(Icons.bookmark_border),
                    subtitle: Text(
                      'Ore: ${format.format(annotation.dateTime)}',
                      style: TextStyle(color: secondaryText),
                    ));
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
            */
            return ValueListenableBuilder(
              valueListenable: Hive.box<Annotation>('annotations').listenable(),
              builder:
                  (BuildContext context, Box<Annotation> value, Widget child) {
                final annotations = value.values
                    .where((annotation) =>
                        annotation.dateTime.isSameDay(dateState.selectedDate))
                    .toList();
                if (annotations.isEmpty) {
                  return Center(
                    child: Text('Nessuna annotazione'),
                  );
                }
                return ListView.separated(
                  itemCount: annotations.length,
                  itemBuilder: (context, index) {
                    final annotation = annotations[index];
                    return ListTile(
                        title: Text(
                          annotation.title,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        leading: Icon(Icons.bookmark_border),
                        subtitle: Text(
                          'Ore: ${format.format(annotation.dateTime)}',
                          style: TextStyle(color: secondaryText),
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                );
              },
            );
          },
        ),
    );
  }
}
