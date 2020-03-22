//final Map<DateTime, Day> fakeDay = Map.fromIterables(
//    rangeDate,
//    rangeDate.map((date) {
//      final day = Day(
//          slices: List.generate(
//            10,
//            (index) {
//              final m = Random().nextInt(200);
//              return Slice(
//                id: m,
//                minutes: m,
//                activity: [
//                  MotionActivity.OnFoot,
//                  MotionActivity.Still
//                ][Random().nextInt(2)],
//              );
//            },
//          ),
//          notes: List.generate(Random().nextInt(30), (index) {
//            return Note(
//                id: index.toString(),
//                dateTime: date.copyWith(
//                    hour: 6 + Random().nextInt(18),
//                    minute: Random().nextInt(60)),
//                text: 'PROVA');
//          }),
//          pointCount: Random().nextInt(400), date: null);
//      return day;
//    }).toList());

//[
//  Day(
//      date: DateTime(2020, 3, 7),
//      slices: [
//        Slice(
//            id: 0,
//            minutes: 70,
//            activity: MotionActivity.OnFoot,
//            startTime: DateTime(2020, 3, 7).add(
//                Duration(hours: 2, minutes: 10,)),
//            endTime: DateTime(2020, 3, 7).add(Duration(hours: 2, minutes: 80,),
//            )
//        ),
//      ]
//  ),
//  Day(
//    date: DateTime(2020, 3, 8),
//    slices:
//  ),
//  Day(
//      date: DateTime(2020, 3, 10),
//      slices: [
//        Slice(
//          id: 0,
//        ),
//      ]
//  ),
//  v
//  Day(
//      date: DateTime(2020, 3, 12),
//      slices: [
//        Slice(
//          id: 0,
//        ),
//      ]
//  ),
//  Day(
//      date: DateTime(2020, 3, 13),
//      slices: [
//        Slice(
//          id: 0,
//        ),
//      ]
//  ),
//
//];

final rangeDate = [
  DateTime(2020, 3, 7),
  DateTime(2020, 3, 8),
  DateTime(2020, 3, 10),
  DateTime(2020, 3, 12),
  DateTime(2020, 3, 13),
];
