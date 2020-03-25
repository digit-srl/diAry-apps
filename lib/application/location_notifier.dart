import 'package:diary/application/root/date_notifier.dart';
import 'package:diary/domain/entities/day.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:diary/utils/extensions.dart';

class LocationState {
//  final List<bg.Location> liveLocations;
  final bg.Location newLocation;

//  final Map<DateTime, Day> _days;

  LocationState(this.newLocation);

//  int get size => liveLocations.length;
}

class LocationNotifier extends StateNotifier<LocationState> with LocatorMixin {
  final Map<DateTime, List<bg.Location>> locationsPerDate;
  final Map<DateTime, Day> days;
  List<bg.Location> liveLocations = [];

  LocationNotifier(this.locationsPerDate, this.days)
      : super(LocationState(null)) {
    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
  }

  List<DateTime> get dates => days.keys.toList();

  List<bg.Location> get getCurrentDayLocations {
    final selectedDay = read<DateNotifier>().selectedDate;
    final locations = locationsPerDate[selectedDay];
    if (locations == null) {
      return liveLocations;
    }
    if (selectedDay.isToday()) {
      locations?.addAll(liveLocations);
    }
    return locations;
  }

  int getTotalPoint(DateTime selectedDate) {
    if (!locationsPerDate.containsKey(selectedDate)) {
      return selectedDate.isToday() ? liveLocations.length : 0;
    }
    return selectedDate.isToday()
        ? locationsPerDate[selectedDate].length + liveLocations.length
        : locationsPerDate[selectedDate].length;
  }

  Day getDay(DateTime selectedDate) {
    Day day;
    if (selectedDate.isToday() && liveLocations.isNotEmpty) {
      final partialSlices = days[selectedDate]?.slices ?? [];
      liveLocations.sort((a, b) => DateTime.tryParse(a.timestamp)
          .compareTo(DateTime.tryParse(b.timestamp)));
      final newSlices = LocationUtils.aggregateLocationsInSlices(
        liveLocations,
        partialDaySlices: partialSlices.isEmpty
            ? []
            : partialSlices.sublist(0, partialSlices.length - 1),
      );
      if (!days.containsKey(selectedDate)) {
        return Day(
            date: selectedDate,
            slices: newSlices,
            pointCount: liveLocations.length);
      }
      day = days[selectedDate]?.copyWith(newSlices);
      return day;
    }
    return days[selectedDate];
  }

  void addLocation(bg.Location location) {
    liveLocations.add(location);
    print('[LocationNotifier] total live locations: ${liveLocations.length}');
    state = LocationState(location);
  }

  void _onLocation(bg.Location location) {
    print('[LocationNotifier] _onLocation()');
    if (location.sample) return;
    print('[LocationNotifier] true loction');
    addLocation(location);
  }

  void _onLocationError(bg.LocationError error) {
    print('[LocationNotifier] _onLocationError()');
  }
}
