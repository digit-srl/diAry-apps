import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/current_root_page_notifier.dart';
import 'package:diary/presentation/widgets/custom_icons_icons.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/application/day_notifier.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/presentation/pages/home/widgets/daily_stats_legend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:diary/domain/entities/day.dart';
import 'package:diary/domain/entities/motion_activity.dart';
import '../../../../utils/styles.dart';
import 'package:provider/provider.dart';

class DailyStats extends StatelessWidget {
  final DateFormat dateFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final height = size.height;
    final _chartSize = Size(height / 3, height / 3);
    return StateNotifierBuilder<DayState>(
      stateNotifier: context.watch<DayNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        print('StateNotifierBuilder STATS DETAILS');

        Day day = value.day;
        print('[DailyStats] selected day: $day');
        List<CircularSegmentEntry> stationarySliceSegments = [];
        List<CircularSegmentEntry> movementSliceSegments = [];
        List<CircularSegmentEntry> annotationSegments = [];
//        DateTime now = DateTime.now();
//        if (day == null) {
////          final slices = List.generate(
////            5,
////            (index) {
////              final m = Random().nextInt(250);
////              return Slice(
////                id: m,
////                minutes: m,
////                activity: [
////                  MotionActivity.OnFoot,
////                  MotionActivity.Still
////                ][Random().nextInt(2)],
////              );
////            },
////          );
//
//          final slices = [
//            Slice(
//              id: 0,
//              minutes: 480,
//              activity: MotionActivity.Still,
//            ),
//            Slice(
//              id: 1,
//              minutes: 15,
//              activity: MotionActivity.OnFoot,
//            ),
//            Slice(
//              id: 2,
//              minutes: 150,
//              activity: MotionActivity.Still,
//            ),
//            Slice(
//              id: 3,
//              minutes: 10,
//              activity: MotionActivity.OnFoot,
//            ),
//            Slice(
//              id: 2,
//              minutes: 140,
//              activity: MotionActivity.Still,
//            ),
//            Slice(
//              id: 3,
//              minutes: 30,
//              activity: MotionActivity.OnFoot,
//            ),
//            Slice(
//              id: 4,
//              minutes: 135,
//              activity: MotionActivity.Still,
//            ),
//            Slice(
//              id: 3,
//              minutes: 5,
//              activity: MotionActivity.OnFoot,
//            ),
//            Slice(
//              id: 4,
//              minutes: 130,
//              activity: MotionActivity.Still,
//            ),
//            Slice(
//              id: 3,
//              minutes: 15,
//              activity: MotionActivity.OnFoot,
//            ),
//            Slice(
//              id: 3,
//              minutes: 20,
//              activity: MotionActivity.Still,
//            ),
//            Slice(
//              id: 3,
//              minutes: 15,
//              activity: MotionActivity.OnFoot,
//            ),
//          ];
//          slices.add(Slice(
//            id: 123,
//            minutes: 295,
//            activity: MotionActivity.Inactive,
//          ));
//          final mmm = [480, 15, 300, 30, 270, 15, 20, 15, 295];
//          print('TODAY MINUTES');
//          print(mmm.reduce((value, element) => value + element).toString());
//
//          final notes = [
//            Note(
//                id: '0',
//                dateTime: now.copyWith(
//                  hour: 9,
//                  minute: 10,
//                ),
//                text: 'PROVA'),
//            Note(
//                id: '0',
//                dateTime: now.copyWith(
//                  hour: 12,
//                  minute: 20,
//                ),
//                text: 'PROVA'),
//            Note(
//                id: '0',
//                dateTime: now.copyWith(
//                  hour: 14,
//                  minute: 10,
//                ),
//                text: 'PROVA'),
//            Note(
//                id: '0',
//                dateTime: now.copyWith(
//                  hour: 18,
//                  minute: 30,
//                ),
//                text: 'PROVA'),
//          ];
//          day = Day(
//              slices: slices, notes: notes, pointCount: Random().nextInt(400));
//        }

        if (day != null) {
          stationarySliceSegments = day.places
//            .where((element) => element.activity == MotionActivity.Still)
              .map<CircularSegmentEntry>((e) {
            Color color;
            if (e.places.isNotEmpty) {
              final String where = e.places.first;
              color = Color(Hive.box<Place>('places').get(where).color);
            } else {
              switch (e.activity) {
                case MotionActivity.Off:
                  color = Colors.black;
                  break;
                case MotionActivity.Inactive:
                  color = Colors.grey[100];
                  break;
                case MotionActivity.Still:
                  if (e.places.isEmpty) {
                    color = Colors.grey;
                  } else {
                    color = Colors.orange;
                  }
                  break;
                default:
                  color = Colors.orange[100];
              }
            }

            /* e.activity == MotionActivity.Still
                    ? Colors.orange
                    : e.activity == MotionActivity.Inactive
                        ? Colors.grey[100]
                        : Colors.orange[100])*/
            return CircularSegmentEntry(
              e.minutes.toDouble(),
              color,
            );
          }).toList();

          movementSliceSegments = day.places
//            .where((element) => element.activity == MotionActivity.OnFoot)
              .map<CircularSegmentEntry>((e) {
            return CircularSegmentEntry(
                e.minutes.toDouble(),
                (e.activity == MotionActivity.OnFoot ||
                        e.activity == MotionActivity.Walking ||
                        e.activity == MotionActivity.Running ||
                        e.activity == MotionActivity.InVehicle ||
                        e.activity == MotionActivity.OnBicycle)
                    ? Colors.blue
                    : e.activity == MotionActivity.Inactive
                        ? Colors.grey[100]
                        : Colors.blue[100]);
          }).toList();

          final annotationSlices = day.annotationSlices;
//        final annotationSlices = <double>[660, 340, 140, 300];
//        day.notes.sort((a, b) => a.dateTime.compareTo(b.dateTime));
//        final date = day.notes.first.dateTime;
//        final minutes = date.hour * 60.0 + date.minute;
//        annotationSlices.add(minutes);
//
//        final newList = day.notes.sublist(1);
//        for (int i = 0; i < newList.length; i++) {
//          final date = newList[i].dateTime;
//          final minutes = date.hour * 60.0 + date.minute;
//          annotationSlices.add(minutes - annotationSlices.last);
//        }
//        final lastMinutes =
//            newList.last.dateTime.hour * 60.0 + newList.last.dateTime.minute;
//        annotationSlices.add(1440.0 - lastMinutes);
//        print(annotationSlices);
//        print(annotationSlices.reduce((value, element) => value + element));
//        day.notes.forEach((element) => print(element.dateTime));
          for (int i = 0; i < annotationSlices.length; i++) {
            if (annotationSlices[i] == 0.0) {
              annotationSegments.add(CircularSegmentEntry(5, Colors.black));
            } else {
              annotationSegments.add(
                  CircularSegmentEntry(annotationSlices[i], Colors.grey[100]));
            }
          }
        }

        if (stationarySliceSegments.isEmpty) {
          stationarySliceSegments
              .add(CircularSegmentEntry(1440, Colors.grey[100]));
        }

        if (movementSliceSegments.isEmpty) {
          movementSliceSegments
              .add(CircularSegmentEntry(1440, Colors.grey[100]));
        }

        if (annotationSegments.isEmpty) {
          annotationSegments.add(CircularSegmentEntry(1440, Colors.grey[100]));
        }

        final data = [
          CircularStackEntry(annotationSegments),
          CircularStackEntry(stationarySliceSegments),
          CircularStackEntry(movementSliceSegments),
        ];

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: _chartSize.height +
                    16, // compensa il padding naturale del grafico
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedCircularChart(
                        key: GlobalKey(),
                        size: _chartSize,
                        initialChartData: data,
                        edgeStyle: SegmentEdgeStyle.flat,
                        chartType: CircularChartType.Radial,
                        labelStyle: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Nunito',
                            color: accentColor,
                            fontWeight: FontWeight.bold),
                        holeLabel: value.isToday
                            ? dateFormat.format(DateTime.now())
                            : null,
                      ),
                    ),
                    Positioned(
//                      alignment: Alignment.bottomCenter,
                      bottom: 16,
                      right: (MediaQuery.of(context).size.width / 2) -
                          (_chartSize.width / 2)
                      //- 16
                      ,
                      child: IconButton(
                          icon: Icon(Icons.help_outline, color: secondaryText),
                          /*
                          Text(
                            '?',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          */
                          onPressed: () {
                            _showPlaceLegend(context);
                          }),
                    ),
//                    Positioned(
////                      alignment: Alignment.bottomCenter,
//                      bottom: 0,
//                      left: (MediaQuery.of(context).size.width / 2) -
//                          (_chartSize.width / 2)
//                          // - 16,
//                          ,
//                      child: IconButton(
//                          icon: Icon(Icons.settings),
//                          onPressed: () {
//                            _showAggregationSettings(context);
//                          }),
//                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // 20
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Flexible(
//                  fit: FlexFit.loose,
                        child: Container(
                          alignment: Alignment.center,
                          child: ButtonTheme(
                            minWidth: double.infinity,
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(16.0),
                              ),
                              onPressed: () {
                                context
                                    .read<CurrentRootPageNotifier>()
                                    .changePage(1);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Campionamenti',
                                    maxLines: 1,
                                    style: secondaryStyle,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(CustomIcons.map_marker_outline),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          day.pointCount.toString(),
                                          style: numberStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: secondaryText,
                      ),
                      Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          child: ButtonTheme(
                            minWidth: double.infinity,
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(16.0),
                              ),
                              onPressed: () {
                                context
                                    .read<CurrentRootPageNotifier>()
                                    .changePage(2);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Segnalazioni',
                                      maxLines: 1, style: secondaryStyle),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          CustomIcons.bookmark_outline,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          (day?.annotations?.length ?? 0)
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: numberStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlaceLegend(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DailyStatsLegend();
        });
    /* Alert(
      context: context,
      title: 'Legenda del grafico',
      content: Container(
          width: MediaQuery.of(context).size.width - 32,
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PlaceLegend(),
            ],
          )),
      buttons: [
        DialogButton(
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();*/
  }

  // only for developers
  void _showAggregationSettings(BuildContext context) {
    final accuracy =
        Hive.box('user').get('aggregationAccuracy', defaultValue: 1000);
    final postProcessingEnabled =
        Hive.box('user').get('postProcessing', defaultValue: true);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return AggregationSettings(
            accuracy: accuracy,
          );
        });
  }
}

class AggregationSettings extends StatefulWidget {
  final int accuracy;
  const AggregationSettings({Key key, this.accuracy}) : super(key: key);
  @override
  _AggregationSettingsState createState() => _AggregationSettingsState();
}

class _AggregationSettingsState extends State<AggregationSettings> {
  TextEditingController accuracy = TextEditingController();

  @override
  void initState() {
    super.initState();
    accuracy = TextEditingController(text: widget.accuracy.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Filtro accuratezza'),
            trailing: Container(
              width: 80,
              alignment: Alignment.center,
              child: TextField(
                controller: accuracy,
                keyboardType: TextInputType.number,
                onSubmitted: (text) {
                  int value = int.tryParse(text);
                  Hive.box('user').put('aggregationAccuracy', value);
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ),
          ListTile(
            title: Text('Post Processing'),
            trailing: Container(
                width: 80,
                alignment: Alignment.center,
                child: Switch(
                    value: Hive.box('user')
                        .get('postProcessing', defaultValue: true),
                    onChanged: (value) {
                      Hive.box('user').put('postProcessing', value);
                      setState(() {});
                    })),
          ),
          GenericButton(
            text: 'Ricalcola',
            onPressed: () {
              context.read<DayNotifier>().processAllLocations();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
//Hive.box('user')
//.get('aggregationAccuracy', defaultValue: 1000),
