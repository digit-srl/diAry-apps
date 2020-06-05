import 'package:diary/domain/entities/day.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/main.dart';
import 'package:diary/utils/constants.dart';
import 'package:diary/utils/logger.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:diary/utils/extensions.dart';

import 'date_notifier.dart';
import 'day_notifier.dart';

class LocationState {
//  final List<bg.Location> liveLocations;
  final Location newLocation;

//  final Map<DateTime, Day> _days;

  LocationState(this.newLocation);

//  int get size => liveLocations.length;
}

class LocationNotifier extends StateNotifier<LocationState> with LocatorMixin {
  final Map<DateTime, List<Location>> locationsPerDate;
//  final Map<DateTime, Day> days;

//  List<bg.Location> liveLocations = [];
//  Map<DateTime, List<bg.Location>> liveLocationsMap = {
//    DateTime.now().withoutMinAndSec(): []
//  };

  LocationNotifier(this.locationsPerDate) : super(LocationState(null)) {
    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
  }

  List<DateTime> get dates => locationsPerDate.keys.toList();
  List<Location> get locations {
    final list = [];
    locationsPerDate.keys.forEach((key) {
      list.addAll(locationsPerDate[key]);
    });
    return list;
  }

  List<Location> get getCurrentDayLocations {
    final selectedDay = read<DateNotifier>().selectedDate;
    final locations = locationsPerDate[selectedDay];
//    if (locations == null) {
//      return liveLocations;
//    }
//    if (selectedDay.isToday) {
//      locations?.addAll(liveLocations);
//    }
    return locations ?? [];
  }

  List<Location> getDayLocationsWithoutZeroLoc(DateTime date) {
    try {
      final dailyLocations = List<Location>.from(locationsPerDate[date]);
      if (dailyLocations.isNotEmpty) {
        dailyLocations.removeWhere((location) => !location.isGoodPoint);
      }
      return dailyLocations;
    } catch (ex) {
      logger.e(ex);
      analytics.logEvent(
          name: '[LocationNotifier] getDayLocationsWithoutZeroLoc',
          parameters: {'error': ex.toString()});
      return [];
    }
  }

//  int getTotalPoint(DateTime selectedDate) {
//    if (!locationsPerDate.containsKey(selectedDate)) {
//      return selectedDate.isToday ? liveLocations.length : 0;
//    }
//    return selectedDate.isToday
//        ? locationsPerDate[selectedDate].length + liveLocations.length
//        : locationsPerDate[selectedDate].length;
//  }

//  Day getDay() {
//    final selectedDate = read<DateNotifier>().selectedDate;
//    Day day;
//    if (selectedDate.isToday && liveLocations.isNotEmpty) {
//      final partialSlices = days[selectedDate]?.slices ?? [];
//      liveLocations.sort((a, b) => DateTime.tryParse(a.timestamp)
//          .compareTo(DateTime.tryParse(b.timestamp)));
//      final newSlices = LocationUtils.aggregateLocationsInSlices(
//        liveLocations,
//        partialDaySlices: partialSlices.isEmpty
//            ? []
//            : partialSlices.sublist(0, partialSlices.length - 1),
//      );
//      if (!days.containsKey(selectedDate)) {
//        return Day(
//            date: selectedDate,
//            slices: newSlices,
//            pointCount: liveLocations.length);
//      }
//      day = days[selectedDate]?.copyWith(newSlices);
//      return day;
//    }
//    return days[selectedDate];
//  }

  void addLocation(Location location) {
    logger.i('[LocationNotifier] total live locations: $location');

    final date = location.dateTime.midnight;

    //aggiorno la map
    if (!locationsPerDate.containsKey(date)) {
      locationsPerDate[date] = [];
    }
    locationsPerDate[date].add(location);
    if (location.isGoodPoint) {
      state = LocationState(location);
    }

    read<DayNotifier>().updateDay2(locationsPerDate, date);
  }

  void _onLocation(bg.Location location) {
    try {
      Hive.box<String>('logs').add('[onLocation] $location');
      logger.i('[LocationNotifier] _onLocation()');
      if (location?.sample ?? false) return;
      logger.i('[LocationNotifier] true loction');
      final loc = Location.fromJson(Map<String, dynamic>.from(location.map));
      addLocation(loc);
    } catch (ex) {
      Hive.box<String>('logs').add('[ERROR onLocation] $ex');
      analytics.logEvent(
          name: '[LocationNotifier] _onLocation',
          parameters: {'error': ex.toString()});
      logger.e('[ERROR onLocation] $ex');
    }
  }

  void _onLocationError(bg.LocationError error) {
    logger.e('[LocationNotifier] _onLocationError()');
    analytics.logEvent(
        name: '[LocationNotifier] _onLocationError',
        parameters: {'error': error.toString()});
  }
}
