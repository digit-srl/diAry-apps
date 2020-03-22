import 'package:diary/domain/entities/slice.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'extensions.dart';
import '../domain/entities/day.dart';
import '../domain/entities/motion_activity.dart';

class LocationUtils {
//  static Future<Map<DateTime, Day>> aggregateLocationRecords() async {
//    Map<DateTime, Day> days = {};
//
//    final Map<DateTime, List<bg.Location>> locationsPerDay =
//        await readAndFilterLocationsPerDay();
//    for (DateTime key in locationsPerDay.keys) {
//      days[key] = Day(
//        date: key,
//        slices: aggregateLocationsInSlices(locationsPerDay[key]),
//      );
//    }
//
//    return days;
//  }

  static Map<DateTime, Day> aggregateLocationsInDayPerDate(
      Map<DateTime, List<bg.Location>> locationsPerDay) {
    Map<DateTime, Day> days = {};
    for (DateTime key in locationsPerDay.keys) {
      days[key] = Day(
          date: key,
          slices: aggregateLocationsInSlices(locationsPerDay[key]),
          pointCount: locationsPerDay[key].length);
    }
    return days;
  }

  static Future<Map<DateTime, List<bg.Location>>>
      readAndFilterLocationsPerDay() async {
    Map<DateTime, List<bg.Location>> locationsPerDay = {};

    List locationsMap = await bg.BackgroundGeolocation.locations;
    print('[LocationUtils] total records: ${locationsMap.length}');
    final DateTime today = DateTime.now().withoutMinAndSec();
    if (locationsMap.isEmpty) {
      return {today: []};
    }
    for (var map in locationsMap) {
      try {
        final bg.Location loc = bg.Location(map);
        final date =
            DateTime.tryParse(loc.timestamp).toLocal().withoutMinAndSec();
        if (!locationsPerDay.containsKey(date)) {
          locationsPerDay[date] = [];
        }
        locationsPerDay[date].add(loc);
      } catch (ex) {
        print('[ERROR _readLocations]\n$map\n$ex');
        print('[END_ERROR _readLocations]');
      }
    }
    locationsPerDay.keys.forEach((element) {
      print(
          '[LocationUtils] day: $element locations: ${locationsPerDay[element].length}');
    });

    return locationsPerDay;
  }

  static List<Slice> aggregateLocationsInSlices(List<bg.Location> locations,
      {List<Slice> partialDaySlices = const []}) {
    if (locations.isEmpty) return [];

    final currentDay = DateTime.tryParse(locations.first.timestamp).toLocal();

    final List<Slice> slices = [];
    slices.addAll(partialDaySlices);
    final maxMinutes = 1440;
    int cumulativeMinutes = partialDaySlices.isNotEmpty
        ? partialDaySlices.last.startTime.hour * 60 +
            partialDaySlices.last.startTime.minute +
            partialDaySlices.last.minutes
        : 0;

    for (bg.Location loc in locations) {
      final currentDate = DateTime.tryParse(loc.timestamp).toLocal();
      final currentMinutes = currentDate.hour * 60 + currentDate.minute;
      final partialMinutes = currentMinutes - cumulativeMinutes;
      final currentActivity = getActivityFromString(loc.activity.type);
      if (slices.isEmpty) {
        slices.add(
          Slice(
            id: 0,
            minutes: partialMinutes,
            activity: MotionActivity.Still,
            startTime: currentDate.withoutMinAndSec(),
          ),
        );
      } else if (slices.last.activity == currentActivity) {
        slices.last.minutes += partialMinutes;
      } else {
        slices.last.minutes += partialMinutes;
        slices.add(
          Slice(
            id: 0,
            minutes: 0,
            activity: currentActivity,
            startTime: currentDate,
          ),
        );
      }
      cumulativeMinutes = currentMinutes;
    }

    print('cumulative minutes before last = $cumulativeMinutes');

    if (cumulativeMinutes < maxMinutes) {
      if (currentDay.isToday()) {
        slices.add(
          Slice(
            id: 0,
            minutes: maxMinutes - cumulativeMinutes,
            activity: MotionActivity.Unknown,
            startTime: slices.last.endTime,
          ),
        );
      } else {
        slices.last.minutes = maxMinutes - cumulativeMinutes;
      }
      cumulativeMinutes += maxMinutes - cumulativeMinutes;
    }

    print('cumulative minutes complete = $cumulativeMinutes');

    return slices;
  }

//  static List<Day> aggregateLocationRecords(List<bg.Location> locations) {
//    if (locations.isEmpty) return [];
//
//    final List<Day> days = [];
//
//    var endTime = DateTime.tryParse(locations.first.timestamp).toLocal();
//    var startTime = DateTime(endTime.year, endTime.month, endTime.day);
//    var totalMinutes = endTime.minute + (endTime.hour * 60);
//    int id = 0;
//    final currentActivity =
//        getActivityFromString(locations.first.activity.type);
//
//    final cloves = <Slice>[
//      Slice(
//        id: id,
//        minutes: totalMinutes,
////        activity: totalMinutes > 30 ? Activity.Inactive : currentActivity,
//        activity: currentActivity,
//        confidence: locations.first.activity.confidence,
//        isMoving: locations.first.isMoving,
//        startTime: startTime,
//        endTime: endTime,
//      ),
//    ];
//
//    id++;
//    final newLocs = locations.sublist(1);
//
//    for (bg.Location loc in newLocs) {
//      final newDate = DateTime.tryParse(loc.timestamp).toLocal();
//      final currentMinutes = newDate.minute + (newDate.hour * 60);
//      final delta = currentMinutes - totalMinutes;
//      final activity = getActivityFromString(loc.activity.type);
//      cloves.last.endTime = newDate;
//      if (cloves.last.activity == activity) {
//        cloves.last.minutes += delta;
//      } else {
//        cloves.last.minutes += delta;
//        cloves.add(
//          Slice(
//              id: id,
//              minutes: 0,
//              activity: getActivityFromString(loc.activity.type),
//              confidence: loc.activity.confidence,
//              isMoving: loc.isMoving,
//              startTime: newDate,
//              endTime: newDate),
//        );
//      }
//
////      if (cloves.last.minutes == 0) {
////        final endTime = cloves.last.endTime;
////      }
//      totalMinutes = newDate.minute + (newDate.hour * 60);
//      id++;
//    }
//
//
//    if (isToday) {
//      final now = DateTime.now();
//      final nowTotalMinutes = now.minute + (now.hour * 60);
//      final difference = nowTotalMinutes - totalMinutes;
//      cloves.last.minutes += difference;
//      cloves.last.isMoving = difference > 30
//          ? null
//          : difference < 5 ? cloves.last.isMoving : false;
//      cloves.last.endTime = now;
////      final newCl = CloveModel(
////        id: id,
////        minutes: difference,
//////        activity: difference > 30 ? Activity.Inactive : cloves.last.activity,
////        activity: cloves.last.activity,
////        confidence: 100,
////        isMoving: difference > 30
////            ? null
////            : difference < 5 ? cloves.last.isMoving : false,
////        startTime: cloves.last.endTime,
////        endTime: now,
////      );
////      cloves.add(newCl);
//      totalMinutes = nowTotalMinutes;
//    }
//
//    final endOfThisDay = DateTime(
//        currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
//    if (cloves.last.endTime.isBefore(endOfThisDay)) {
//      //TODO essendo l ultimo spicchio lo basiamo su ciò che faceva nel penultimo?
//      cloves.add(
//        CloveModel(
//          id: ++id,
//          minutes: 1440 - totalMinutes,
//          activity: isToday ? MotionActivity.Unknown : cloves.last.activity,
//          confidence: 100,
//          isMoving: isToday ? null : cloves.last.isMoving,
//          startTime: cloves.last.endTime,
//          endTime: DateTime(
//              currentDate.year, currentDate.month, currentDate.day, 23, 59, 59),
//        ),
//      );
//    }
//
//    final tmp = <Slice>[];
//    var t = 0;
//    for (int i = 0; i < cloves.length; i++) {
//      t += cloves[i].minutes;
//      print(cloves[i]);
//    }
//    print('--------------');
//    for (Slice t in tmp) print(t);
//    print('total minutes: $t');
//    return days;
//  }
}
