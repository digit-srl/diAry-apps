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
    this.places,
    this.placeRecords = 0,
  }) {
    if (this.places == null) {
      this.places = {};
    }
  }

  removePlace(String place) {
    places.remove(place);
  }

  add(String place) {
    places.add(place);
  }

  String get formattedMinutes => GenericUtils.minutesToString(minutes);
}
