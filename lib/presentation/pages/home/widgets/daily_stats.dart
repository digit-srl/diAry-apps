import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:intl/intl.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/root/date_notifier.dart';
import 'package:diary/domain/entities/day.dart';
import 'package:diary/domain/entities/motion_activity.dart';
import '../../../../utils/styles.dart';
import 'package:provider/provider.dart';

class DailyStats extends StatelessWidget {
  DateFormat dateFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final height = size.height;
    final _chartSize = Size(height / 3, height / 3);
    return StateNotifierBuilder<DateState>(
      stateNotifier: context.watch<DateNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        print('StateNotifierBuilder STATS DETAILS');

        Day day = Provider.of<LocationNotifier>(context, listen: false)
            .getDay(value.selectedDate);
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
          stationarySliceSegments = day.slices
//            .where((element) => element.activity == MotionActivity.Still)
              .map<CircularSegmentEntry>((e) => CircularSegmentEntry(
                  e.minutes.toDouble(),
                  e.activity == MotionActivity.Still
                      ? Colors.orange
                      : e.activity == MotionActivity.Inactive
                          ? Colors.grey[100]
                          : Colors.orange[100]))
              .toList();

          movementSliceSegments = day.slices
//            .where((element) => element.activity == MotionActivity.OnFoot)
              .map<CircularSegmentEntry>((e) => CircularSegmentEntry(
                  e.minutes.toDouble(),
                  (e.activity == MotionActivity.OnFoot ||
                          e.activity == MotionActivity.Walking ||
                          e.activity == MotionActivity.Running ||
                          e.activity == MotionActivity.InVehicle ||
                          e.activity == MotionActivity.OnBicycle)
                      ? Colors.blue
                      : e.activity == MotionActivity.Inactive
                          ? Colors.grey[100]
                          : Colors.blue[100]))
              .toList();

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
              AnimatedCircularChart(
                key: GlobalKey(),
                size: _chartSize,
                initialChartData: data,
                edgeStyle: SegmentEdgeStyle.flat,
                chartType: CircularChartType.Radial,
                labelStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                holeLabel:
                    value.isToday ? dateFormat.format(DateTime.now()) : null,
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
                                      Provider.of<LocationNotifier>(context,
                                              listen: false)
                                          .getTotalPoint(value.selectedDate)
                                          .toString(),
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
                                      (day?.notes?.length ?? 0).toString(),
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
}
