import 'package:diary/utils/generic_utils.dart';
import 'motion_activity.dart';

class Slice {
  final int id;
  final DateTime startTime;
  MotionActivity activity;
  Set<String> places;
  int minutes;
  int placeRecords;

  DateTime get endTime =>
      startTime.add(GenericUtils.minutesToDuration(minutes));

  Slice({
    this.id,
    this.minutes = 0,
    this.startTime,
    this.activity,
    this.places = const {},
    this.placeRecords = 0,
  });

  String get formattedMinutes => GenericUtils.minutesToString(minutes);
}
