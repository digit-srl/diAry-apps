import 'package:diary/application/date_notifier.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/current_root_page_notifier.dart';
import 'package:diary/utils/custom_icons.dart';
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
import 'package:sliding_sheet/sliding_sheet.dart';
import '../../../../utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:diary/utils/extensions.dart';

class DailyStatsPageView extends StatefulWidget {
  @override
  _DailyStatsPageViewState createState() => _DailyStatsPageViewState();
}

class _DailyStatsPageViewState extends State<DailyStatsPageView> {
  Map<DateTime, Day> days;
  @override
  void initState() {
    super.initState();
    days = context.read<DayNotifier>().days;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
//
//
    context.read<DayNotifier>().addListener(
      (state) {
        print('[DailyStatsPageView] DayNotifier');
        days[state.day.date] = state.day;
      },
      fireImmediately: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = days.values.toList();
    return Container(
      height: 400,
      child: PageView.builder(
        itemCount: days.values.length,
        onPageChanged: (index) {
          context.read<DateNotifier>().changeSelectedDate(list[index].date);
        },
        itemBuilder: (ctx, index) {
          return DailyStatsWidget2(
            day: list[index],
          );
        },
      ),
    );
  }
}

class DailyStatsWidget extends StatelessWidget {
  final DateFormat dateFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final height = size.height;
    final bool isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // misure euristiche, dipendenti dal valore di height
    final _chartSize = Size(height / 3, height / 3);
    final _overlayLegendPaddingTop = height / 26;
    final _overlayLegendTextHeight = height / 48;
    return StateNotifierBuilder<DayState>(
      stateNotifier: context.watch<DayNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        print('StateNotifierBuilder STATS DETAILS');

        Day day = value.day;
        print('[DailyStatsWidget] selected day: $day');
        List<CircularSegmentEntry> stationarySliceSegments = [];
        List<CircularSegmentEntry> movementSliceSegments = [];
        List<CircularSegmentEntry> annotationSegments = [];

        if (day != null) {
          stationarySliceSegments = day.places.map<CircularSegmentEntry>((e) {
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

            return CircularSegmentEntry(
              e.minutes.toDouble(),
              color,
            );
          }).toList();

          movementSliceSegments = day.places.map<CircularSegmentEntry>((e) {
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
                        labelStyle: Theme.of(context).textTheme.headline,
                        holeLabel: value.isToday
                            ? dateFormat.format(DateTime.now())
                            : null,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.6),
                        width: size.width / 2,
                        padding: EdgeInsets.only(
                            top: _overlayLegendPaddingTop, right: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                child: FittedBox(
                                  child: Text("Spostamenti",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  fit: BoxFit.none,
                                  alignment: Alignment.centerRight,
                                ),
                                height: _overlayLegendTextHeight,
                                width: size.width / 2),
                            Container(
                                child: FittedBox(
                                  child: Text("Luoghi",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  fit: BoxFit.none,
                                  alignment: Alignment.centerRight,
                                ),
                                height: _overlayLegendTextHeight,
                                width: size.width / 2),
                            Container(
                                child: FittedBox(
                                  child: Text("Annotazioni",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  fit: BoxFit.none,
                                  alignment: Alignment.centerRight,
                                ),
                                height: _overlayLegendTextHeight,
                                width: size.width / 2),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: (MediaQuery.of(context).size.width / 2) -
                          (_chartSize.width / 2),
                      child: IconButton(
                          icon: Icon(Icons.help_outline,
                              color: Theme.of(context).textTheme.body1.color),
                          onPressed: () {
                            _showPlaceLegend(context);
                          }),
                    ),
                    /*
                    Positioned(
                      alignment: Alignment.bottomCenter,
                      bottom: 0,
                      left: (MediaQuery.of(context).size.width / 2) - (_chartSize.width / 2),
                      child: IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          _showAggregationSettings(context);
                        }
                      ),
                    ),
                    */
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // 20
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        highlightColor: Theme.of(context)
                            .textTheme
                            .body1
                            .color
                            .withOpacity(0.3),
                        splashColor: Theme.of(context)
                            .textTheme
                            .body1
                            .color
                            .withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(16.0),
                        ),
                        onPressed: () {
                          context.read<CurrentRootPageNotifier>().changePage(1);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AutoSizeText(
                              'Campionamenti',
                              maxLines: 1,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    CustomIcons.map_marker_outline,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    day.pointCount.toString(),
                                    style: Theme.of(context).textTheme.headline,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        highlightColor: Theme.of(context)
                            .textTheme
                            .body1
                            .color
                            .withOpacity(0.3),
                        splashColor: Theme.of(context)
                            .textTheme
                            .body1
                            .color
                            .withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(16.0),
                        ),
                        onPressed: () {
                          context.read<CurrentRootPageNotifier>().changePage(2);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AutoSizeText('Annotazioni',
                                maxLines: 1,
                                style: Theme.of(context).textTheme.body1),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    CustomIcons.bookmark_outline,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    (day?.annotations?.length ?? 0).toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlaceLegend(BuildContext context) async {
    await showSlidingBottomSheet(context, useRootNavigator: true,
        builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        //minHeight: 400,
        duration: Duration(milliseconds: 300),
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [SnapSpec.expanded],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (ctx, sheetState) {
          return Container(
            child: Material(
              color: Colors.white,
              child: DailyStatsLegend(),
            ),
          );
        },
      );
    });
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

class DailyStatsWidget2 extends StatelessWidget {
  final Day day;
  final DateFormat dateFormat = DateFormat('HH:mm');
  DailyStatsWidget2({Key key, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final height = size.height;
    final _chartSize = Size(height / 3, height / 3);
    print('[DailyStatsWidget] selected day: $day');
    List<CircularSegmentEntry> stationarySliceSegments = [];
    List<CircularSegmentEntry> movementSliceSegments = [];
    List<CircularSegmentEntry> annotationSegments = [];

    if (day != null) {
      stationarySliceSegments = day.places.map<CircularSegmentEntry>((e) {
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

        return CircularSegmentEntry(
          e.minutes.toDouble(),
          color,
        );
      }).toList();

      movementSliceSegments = day.places.map<CircularSegmentEntry>((e) {
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
      for (int i = 0; i < annotationSlices.length; i++) {
        if (annotationSlices[i] == 0.0) {
          annotationSegments.add(CircularSegmentEntry(5, Colors.black));
        } else {
          annotationSegments
              .add(CircularSegmentEntry(annotationSlices[i], Colors.grey[100]));
        }
      }
    }

    if (stationarySliceSegments.isEmpty) {
      stationarySliceSegments.add(CircularSegmentEntry(1440, Colors.grey[100]));
    }

    if (movementSliceSegments.isEmpty) {
      movementSliceSegments.add(CircularSegmentEntry(1440, Colors.grey[100]));
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
            height: _chartSize.height,
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
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    holeLabel: day.date.isToday()
                        ? dateFormat.format(DateTime.now())
                        : null,
                  ),
                ),
                Positioned(
//                      alignment: Alignment.bottomCenter,
                  bottom: 0,
                  right: (MediaQuery.of(context).size.width / 2) -
                      (_chartSize.width / 2) -
                      16,
                  child: IconButton(
                      icon: Text(
                        '?',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
//                        _showPlaceLegend(context);
                      }),
                ),
//                    Positioned(
////                      alignment: Alignment.bottomCenter,
//                      bottom: 0,
//                      left: (MediaQuery.of(context).size.width / 2) -
//                          (_chartSize.width / 2) -
//                          16,
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
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Flexible(
//                  fit: FlexFit.loose,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Campionamenti',
                            maxLines: 1,
                            style: secondaryStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.place),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  day.pointCount.toString(),
                                  //style: numberStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    color: Colors.black,
                  ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Segnalazioni',
                              maxLines: 1, style: secondaryStyle),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.bookmark_border,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  (day?.annotations?.length ?? 0).toString(),
                                  textAlign: TextAlign.center,
                                  //style: numberStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
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
