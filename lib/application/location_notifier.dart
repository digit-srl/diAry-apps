import 'package:diary/domain/entities/day.dart';
import 'package:diary/domain/entities/location.dart';
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
  final Map<DateTime, Day> days;

//  List<bg.Location> liveLocations = [];
//  Map<DateTime, List<bg.Location>> liveLocationsMap = {
//    DateTime.now().withoutMinAndSec(): []
//  };

  LocationNotifier(this.locationsPerDate, this.days)
      : super(LocationState(null)) {
    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
  }

  List<DateTime> get dates => locationsPerDate.keys.toList();

  List<Location> get getCurrentDayLocations {
    final selectedDay = read<DateNotifier>().selectedDate;
    final locations = locationsPerDate[selectedDay];
//    if (locations == null) {
//      return liveLocations;
//    }
//    if (selectedDay.isToday()) {
//      locations?.addAll(liveLocations);
//    }
    return locations ?? [];
  }

//  int getTotalPoint(DateTime selectedDate) {
//    if (!locationsPerDate.containsKey(selectedDate)) {
//      return selectedDate.isToday() ? liveLocations.length : 0;
//    }
//    return selectedDate.isToday()
//        ? locationsPerDate[selectedDate].length + liveLocations.length
//        : locationsPerDate[selectedDate].length;
//  }

//  Day getDay() {
//    final selectedDate = read<DateNotifier>().selectedDate;
//    Day day;
//    if (selectedDate.isToday() && liveLocations.isNotEmpty) {
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
    print('[LocationNotifier] total live locations: $location');

    state = LocationState(location);

    final date =
        DateTime.tryParse(location.timestamp).toLocal().withoutMinAndSec();

    //aggiorno la map
    if (!locationsPerDate.containsKey(date)) {
      locationsPerDate[date] = [];
    }
    locationsPerDate[date].add(location);
    read<DayNotifier>().updateDay(location, date);
  }

//  void addLocation(bg.Location location) {
//    final newLocationDate =
//        DateTime.tryParse(location.timestamp).toLocal().withoutMinAndSec();
//    if (!liveLocationsMap.containsKey(newLocationDate)) {
//      liveLocationsMap[newLocationDate] = <bg.Location>[];
//    }
//    liveLocationsMap[newLocationDate].add(location);
//    print('[LocationNotifier] total live locations: $liveLocationsMap');
//
//    state = LocationState(location);
//
//    read<DayNotifier>().updateDay(liveLocationsMap);
//    liveLocationsMap.clear();
//  }

//  void addNewLocation(bg.Location location) {
//    liveLocations.add(location);
//    state = LocationState(location);
//
//    liveLocations.sort((a, b) => DateTime.tryParse(a.timestamp)
//        .compareTo(DateTime.tryParse(b.timestamp)));
//    read<DayNotifier>().updateDay(liveLocations);
//  }

  void _onLocation(bg.Location location) {
    Hive.box<String>('logs').add('[onLocation] $location');
    print('[LocationNotifier] _onLocation()');
    if (location?.sample ?? false) return;
    print('[LocationNotifier] true loction');
    try {
      final loc = Location.fromJson(Map<String, dynamic>.from(location.map));
      addLocation(loc);
    } catch (ex) {
      print('[ERROR] $ex');
    }
  }

  void _onLocationError(bg.LocationError error) {
    print('[LocationNotifier] _onLocationError()');
  }
}
