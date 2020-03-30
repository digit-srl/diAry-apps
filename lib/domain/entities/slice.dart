import 'motion_activity.dart';

class Slice {
  final int id;
  final DateTime startTime;
  MotionActivity activity;
  Set<String> places;
  int minutes;
  int placeRecords;

  DateTime get endTime => startTime.add(minutesToHourAndMinutes(minutes));

  Slice({
    this.id,
    this.minutes,
    this.startTime,
    this.activity,
    this.places = const {},
    this.placeRecords = 0,
  });

  Duration minutesToHourAndMinutes(int minutes) {
    final x = minutes / 60.0;
    int hours = x.toInt();
    String minString = x.toString().split('.')[1].substring(0, 1);
    int min = (int.parse(minString) / 100 * 60).truncate();
    return Duration(hours: hours, minutes: min);
//    if (min == 0) return '${hours} h';
//    return '${hours} h : ${min} m';
  }

  String get formattedMinutes =>
      minutes > 60 ? minutesToHour() : '$minutes min';

  String minutesToHour() {
    final x = minutes / 60.0;
    int hours = x.toInt();
    String minString = x.toStringAsFixed(2).split('.')[1];
    int min = (int.parse(minString) / 100 * 60).truncate();
    if (min == 0) return '$hours h';
    return '$hours h : $min m';
  }
}
