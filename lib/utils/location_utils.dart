import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/domain/entities/slice.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'extensions.dart';
import '../domain/entities/day.dart';
import '../domain/entities/motion_activity.dart';

enum Action { Enter, Exit, Unknown }

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

  static void getCurrentLocationAndUpdateMap(
      Function(bg.Location) onDone, Function(dynamic) onError) {
    bg.BackgroundGeolocation.getCurrentPosition(
      persist: true,
      maximumAge: 5000,
      timeout: 10,
      samples: 5,
      desiredAccuracy: 5,
      extras: {"getCurrentPosition": true},
    ).then(onDone, onError: onError);
  }

  static Map<DateTime, Day> aggregateLocationsInDayPerDate(
      Map<DateTime, List<Location>> locationsPerDay) {
    Map<DateTime, Day> days = {};
    for (DateTime key in locationsPerDay.keys) {
//      final tmp = aggregateLocationsInSlices(locationsPerDay[key],
//          box:
//              Map<String, bool>.from(Hive.box<bool>('enabled_change').toMap()));
      final tmp = aggregateLocationsInSlices3(locationsPerDay[key]);
      days[key] = Day(
          date: key,
          slices: tmp[0],
          places: tmp[1],
          annotations: Hive.box<Annotation>('annotations')
              .values
              .where((annotation) => annotation.dateTime.isSameDay(key))
              .toList(),
          pointCount: locationsPerDay[key].length);
    }
    return days;
  }

  static Future<Map<DateTime, List<Location>>>
      readAndFilterLocationsPerDay() async {
    Map<DateTime, List<Location>> locationsPerDay = {};

    List locationsMap = await bg.BackgroundGeolocation.locations;
    print('[LocationUtils] total records: ${locationsMap.length}');
    final DateTime today = DateTime.now().withoutMinAndSec();
    if (locationsMap.isEmpty) {
      return {today: []};
    }
    for (var map in locationsMap) {
      try {
        final Location loc = Location.fromJson(Map<String, dynamic>.from(map));
        final speed = loc?.coords?.speed ?? 0.0;
        if (speed < 0.5) {
          final currentActivity = loc.activity.type;
          loc.activity.type = 'still';
          print('Set to STILL record with speed < 1.0 m/s');
          print(
              'Before was $currentActivity with speed: ${loc.coords.speed} m/s');
        }
        final date =
            DateTime.tryParse(loc.timestamp).toLocal().withoutMinAndSec();
        if (!locationsPerDay.containsKey(date)) {
          locationsPerDay[date] = [];
        }
        locationsPerDay[date].add(loc);
      } catch (ex) {
        print('[ERROR] _readLocations \n$map\n$ex');
        print('[END_ERROR _readLocations');
      }
    }
    locationsPerDay.keys.forEach((element) {
      print(
          '[LocationUtils] day: $element locations: ${locationsPerDay[element].length}');
    });

    return locationsPerDay;
  }

  Map<DateTime, bool> fakeActive = {
    DateTime(2020, 3, 27, 17, 22): false,
    DateTime(2020, 3, 27, 17, 25): true,
  };

//  static List<List<Slice>> aggregateLocationsInSlices(
//      List<bg.Location> locations,
//      {Map<String, bool> box,
//      List<Slice> partialDaySlices = const [],
//      List<Slice> partialDayPlaces = const []}) {
//    if (locations.isEmpty) return [[], []];
//
//    final currentDay = DateTime.tryParse(locations.first.timestamp).toLocal();
//
//    // on/off config
//    final List<DateTime> enablingHistory =
//        List<DateTime>.from(box.keys.map((el) => DateTime.parse(el)));
//    enablingHistory.sort((DateTime a, DateTime b) => a.compareTo(b));
//    final currentEnablingDayHistory =
//        enablingHistory.where((a) => a.isSameDay(currentDay)).toList();
//
//    final List<Slice> slices = [];
//    final List<Slice> places = [];
//
//    Action lastAction = Action.Unknown;
//    bool isFirstGeofence = true;
//    String lastWhere;
//    slices.addAll(partialDaySlices);
//    places.addAll(partialDayPlaces);
//
//    final maxMinutes = 1440;
//    int cumulativeMinutes = partialDaySlices.isNotEmpty
//        ? partialDaySlices.last.startTime.hour * 60 +
//            partialDaySlices.last.startTime.minute +
//            partialDaySlices.last.minutes
//        : 0;
//
//    int cumulativePlacesMinutes = partialDayPlaces.isNotEmpty
//        ? partialDayPlaces.last.startTime.hour * 60 +
//            partialDayPlaces.last.startTime.minute +
//            partialDayPlaces.last.minutes
//        : 0;
//
//    int abilitationIndex = 0;
//
//    for (bg.Location loc in locations) {
//      final currentDate = DateTime.tryParse(loc.timestamp).toLocal();
//      final currentMinutes = currentDate.hour * 60 + currentDate.minute;
//      final partialMinutes = currentMinutes - cumulativeMinutes;
//      final currentActivity = getActivityFromString(loc.activity.type);
//
//      int partialPlaceMinutes = currentMinutes - cumulativePlacesMinutes;
//
//      //gofence data
//      final geofence = loc.geofence;
//      final action = geofence?.action == null
//          ? Action.Unknown
//          : geofence?.action == 'EXIT' ? Action.Exit : Action.Enter;
//      final where = geofence?.identifier;
//      print('uuid: ${loc.uuid}, identifier: $where, action: $action');
//
//      final d = currentEnablingDayHistory.isEmpty
//          ? null
//          : abilitationIndex >= currentEnablingDayHistory.length
//              ? null
//              : currentEnablingDayHistory[abilitationIndex];
//      if (d != null && d.isBefore(currentDate)) {
//        final dCurrent = d.hour * 60 + d.minute;
//        if (box[d.toIso8601String()]) {
//          places.add(
//            Slice(
//              id: 0,
//              minutes: partialPlaceMinutes - (currentMinutes - dCurrent),
//              startTime: currentDate.withoutMinAndSec(),
//              places: {},
//              activity: MotionActivity.Off,
//            ),
//          );
//          cumulativePlacesMinutes += dCurrent;
//          partialPlaceMinutes = currentMinutes - cumulativePlacesMinutes;
//
////          if (places.isEmpty) {
////          } else {}
////          if (places.last.activity == MotionActivity.Off) {
////            places.last.minutes += partialPlaceMinutes;
////          } else {
////            places.last.minutes += partialPlaceMinutes;
////            places.add(
////              Slice(
////                id: 0,
////                minutes: dCurrent,
////                startTime: currentDate.withoutMinAndSec(),
////                places: {},
////                activity: MotionActivity.Off,
////              ),
////            );
////          }
//
//        } else {
//          places.last.minutes += dCurrent - cumulativePlacesMinutes;
//          cumulativePlacesMinutes += places.last.minutes;
//          abilitationIndex++;
//          final c = currentEnablingDayHistory[abilitationIndex];
//          final cCurrent = c.hour * 60 + c.minute;
//          if (box[c.toIso8601String()]) {
//            places.add(
//              Slice(
//                id: 0,
//                minutes: 0,
//                startTime: d,
//                places: {},
//                activity: MotionActivity.Off,
//              ),
//            );
////            cumulativePlacesMinutes += cCurrent - dCurrent;
//            partialPlaceMinutes = cCurrent - dCurrent;
//          }
//        }
//        abilitationIndex++;
//      }
//
//      //se places è vuoto aggiungo slice con place nullo o meno in base al geofence se exit o action
//      if (places.isEmpty) {
//        places.add(
//          Slice(
//            id: 0,
//            minutes: partialPlaceMinutes,
//            startTime: currentDate.withoutMinAndSec(),
//            places: action == Action.Unknown ? {} : {where},
//            activity: action == Action.Unknown
//                ? currentActivity
//                : MotionActivity.Still,
//            placeRecords: 1,
//          ),
//        );
//      } else if (loc.geofence == null) {
//        places.last.minutes += partialPlaceMinutes;
//        if (lastAction == Action.Enter) {
//          //ultima azione = Enter
//          places.last.placeRecords += 1;
//        } else if (lastAction == Action.Unknown) {
//          //ultima azione = Unknown
//          if (places.last.places.isEmpty) {
//            if (places.last.activity == currentActivity ||
//                places.last.activity == MotionActivity.Unknown) {
//              places.last.placeRecords += 1;
//            } else {
//              places.add(
//                Slice(
//                  id: 0,
//                  minutes: 0,
//                  activity: currentActivity,
//                  startTime: currentDate,
//                  places: {},
//                  placeRecords: 1,
//                ),
//              );
//            }
//          } else {
//            places.last.placeRecords += 1;
//          }
//        } else {
//          // ultima azione = EXIT
//          Set<String> newPlaces = Set.from(places.last.places);
//          if (newPlaces.contains(lastWhere)) {
//            newPlaces.remove(lastWhere);
//          }
//          if (places.last.places.isEmpty) {
//            if (places.last.activity == currentActivity ||
//                places.last.activity == MotionActivity.Unknown) {
//              places.last.activity = currentActivity;
//              places.last.placeRecords += 1;
//            } else {
//              places.add(
//                Slice(
//                  id: 0,
//                  minutes: 0,
//                  startTime: currentDate,
//                  places: newPlaces,
//                  activity: currentActivity,
//                  placeRecords: 1,
//                ),
//              );
//            }
//          } else {
//            places.last.placeRecords += 1;
//          }
//        }
//      } else {
//        //Geofence presente
//        places.last.minutes += partialPlaceMinutes;
//
//        if (action == Action.Enter) {
//          if (!places.last.places.contains(where)) {
//            Set<String> newPlaces = Set.from(places.last.places);
//            newPlaces.add(where);
//            places.add(
//              Slice(
//                id: 0,
//                minutes: 0,
//                startTime: currentDate,
//                places: newPlaces,
//                activity: MotionActivity.Still,
//                placeRecords: 1,
//              ),
//            );
//          } else {
//            places.last.placeRecords += 1;
//          }
//        } else if (action == Action.Exit) {
//          places.last.placeRecords += 1;
//          //situazione di primo EXIT della giornata visto che ol luogo non è contenuto nel precedente spicchio
//          if (isFirstGeofence) {
//            places.last.places.add(where);
//          }
//          //TODO potrebbe anche uscire da 2 posti di fila
//
//          Set<String> newPlaces = Set.from(places.last.places);
//          if (newPlaces.contains(where)) {
//            newPlaces.remove(where);
//          }
//
//          places.add(
//            Slice(
//              id: 0,
//              minutes: 0,
//              startTime: currentDate,
//              places: newPlaces,
//              activity: newPlaces.isEmpty
//                  ? MotionActivity.Unknown
//                  : MotionActivity.Still,
//              placeRecords: 0,
//            ),
//          );
//        }
//        isFirstGeofence = false;
//      }
//
//      lastAction = action;
//      lastWhere = where;
//      cumulativePlacesMinutes = currentMinutes;
//
//      if (slices.isEmpty) {
//        slices.add(
//          Slice(
//            id: 0,
//            minutes: partialMinutes,
//            activity: MotionActivity.Still,
//            startTime: currentDate.withoutMinAndSec(),
//          ),
//        );
//      } else if (slices.last.activity == currentActivity) {
//        slices.last.minutes += partialMinutes;
//      } else {
//        slices.last.minutes += partialMinutes;
//        slices.add(
//          Slice(
//            id: 0,
//            minutes: 0,
//            activity: currentActivity,
//            startTime: currentDate,
//          ),
//        );
//      }
//      cumulativeMinutes = currentMinutes;
//    }
//
//    print('cumulative minutes before last = $cumulativeMinutes');
//
//    if (cumulativePlacesMinutes < maxMinutes) {
//      if (currentDay.isToday()) {
//        places.add(
//          Slice(
//            id: 0,
//            minutes: maxMinutes - cumulativePlacesMinutes,
//            startTime: places.last.endTime,
//            places: {},
//          ),
//        );
//      } else if (currentEnablingDayHistory != null &&
//          currentEnablingDayHistory.isNotEmpty) {
//        final last = currentEnablingDayHistory?.last;
//        if (last != null &&
//            last.isAfter(DateTime.parse(locations.last.timestamp))) {
//          if (!box[currentEnablingDayHistory.last.toIso8601String()]) {
//            places.add(
//              Slice(
//                id: 0,
//                minutes: maxMinutes - cumulativePlacesMinutes,
//                startTime: places.last.endTime,
//                places: {},
//                activity: MotionActivity.Off,
//              ),
//            );
//          }
//        } else {
//          places.last.minutes = maxMinutes - cumulativePlacesMinutes;
//        }
//      }
//      cumulativePlacesMinutes += maxMinutes - cumulativePlacesMinutes;
//    }
//
//    if (cumulativeMinutes < maxMinutes) {
//      if (currentDay.isToday()) {
//        slices.add(
//          Slice(
//            id: 0,
//            minutes: maxMinutes - cumulativeMinutes,
//            activity: MotionActivity.Unknown,
//            startTime: slices.last.endTime,
//          ),
//        );
//      } else {
//        slices.last.minutes = maxMinutes - cumulativeMinutes;
//      }
//      cumulativeMinutes += maxMinutes - cumulativeMinutes;
//    }
//
//    print('cumulative minutes complete = $cumulativeMinutes');
//
//    return [slices, places];
//  }

  static List<List<Slice>> aggregateLocationsInSlices3(List<Location> locations,
      {List<Slice> partialDaySlices = const [],
      List<Slice> partialDayPlaces = const []}) {
    if (locations.isEmpty) return [[], []];

    final currentDay = DateTime.tryParse(locations.first.timestamp).toLocal();

    final List<Slice> slices = [];
    final List<Slice> places = [];

    Action lastAction = Action.Unknown;
    bool isFirstGeofence = true;
    String lastWhere;
    slices.addAll(partialDaySlices);
    places.addAll(partialDayPlaces);

    final maxMinutes = 1440;
    int cumulativeMinutes = partialDaySlices.isNotEmpty
        ? partialDaySlices.last.startTime.toMinutes() +
            partialDaySlices.last.minutes
        : 0;

    int cumulativePlacesMinutes = partialDayPlaces.isNotEmpty
        ? partialDayPlaces.last.startTime.toMinutes() +
            partialDayPlaces.last.minutes
        : 0;

    for (Location loc in locations) {
      final currentDate = DateTime.tryParse(loc.timestamp).toLocal();
      final currentMinutes = currentDate.toMinutes();
      final partialMinutes = currentMinutes - cumulativeMinutes;
      final currentActivity = getActivityFromString(loc.activity.type);

      int partialPlaceMinutes = currentMinutes - cumulativePlacesMinutes;

      //gofence data
      final geofence = loc.geofence;
      final action = geofence?.action == null
          ? Action.Unknown
          : geofence?.action == 'EXIT' ? Action.Exit : Action.Enter;
      final where = geofence?.identifier;
      print('uuid: ${loc.uuid}, identifier: $where, action: $action');

      //se places è vuoto aggiungo slice con place nullo o meno in base al geofence se exit o action
      if (places.isEmpty) {
        places.add(
          Slice(
            id: 0,
            minutes: partialPlaceMinutes,
            startTime: currentDate.withoutMinAndSec(),
            places: action == Action.Unknown ? {} : {where},
            activity: action == Action.Unknown
                ? currentActivity
                : MotionActivity.Still,
            placeRecords: 1,
          ),
        );
      } else if (loc.geofence == null) {
        places.last.minutes += partialPlaceMinutes;
        if (lastAction == Action.Enter) {
          //ultima azione = Enter
          places.last.placeRecords += 1;
        } else if (lastAction == Action.Unknown) {
          //ultima azione = Unknown
          if (places.last.places.isEmpty) {
            if (places.last.activity == currentActivity ||
                places.last.activity == MotionActivity.Unknown) {
              places.last.placeRecords += 1;
            } else {
              places.add(
                Slice(
                  id: 0,
                  minutes: 0,
                  activity: currentActivity,
                  startTime: currentDate,
                  places: {},
                  placeRecords: 1,
                ),
              );
            }
          } else {
            places.last.placeRecords += 1;
          }
        } else {
          // ultima azione = EXIT
          Set<String> newPlaces = Set.from(places.last.places);
          if (newPlaces.contains(lastWhere)) {
            newPlaces.remove(lastWhere);
          }
          if (places.last.places.isEmpty) {
            if (places.last.activity == currentActivity ||
                places.last.activity == MotionActivity.Unknown) {
              places.last.activity = currentActivity;
              places.last.placeRecords += 1;
            } else {
              places.add(
                Slice(
                  id: 0,
                  minutes: 0,
                  startTime: currentDate,
                  places: newPlaces,
                  activity: currentActivity,
                  placeRecords: 1,
                ),
              );
            }
          } else {
            places.last.placeRecords += 1;
          }
        }
      } else {
        //Geofence presente
        places.last.minutes += partialPlaceMinutes;

        if (action == Action.Enter) {
          if (!places.last.places.contains(where)) {
            Set<String> newPlaces = Set.from(places.last.places);
            newPlaces.add(where);
            places.add(
              Slice(
                id: 0,
                minutes: 0,
                startTime: currentDate,
                places: newPlaces,
                activity: MotionActivity.Still,
                placeRecords: 1,
              ),
            );
          } else {
            places.last.placeRecords += 1;
          }
        } else if (action == Action.Exit) {
          places.last.placeRecords += 1;
          //situazione di primo EXIT della giornata visto che ol luogo non è contenuto nel precedente spicchio
          if (isFirstGeofence) {
            places.last.places.add(where);
          }
          //TODO potrebbe anche uscire da 2 posti di fila

          Set<String> newPlaces = Set.from(places.last.places);
          if (newPlaces.contains(where)) {
            newPlaces.remove(where);
          }

          places.add(
            Slice(
              id: 0,
              minutes: 0,
              startTime: currentDate,
              places: newPlaces,
              activity: newPlaces.isEmpty
                  ? MotionActivity.Unknown
                  : MotionActivity.Still,
              placeRecords: 0,
            ),
          );
        }
        isFirstGeofence = false;
      }

      lastAction = action;
      lastWhere = where;
      cumulativePlacesMinutes = currentMinutes;

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

    if (cumulativePlacesMinutes < maxMinutes) {
      if (currentDay.isToday()) {
        places.add(
          Slice(
            id: 0,
            minutes: maxMinutes - cumulativePlacesMinutes,
            startTime: places.last.endTime,
            places: {},
          ),
        );
      } else {
        places.last.minutes = maxMinutes - cumulativePlacesMinutes;
      }
      cumulativePlacesMinutes += maxMinutes - cumulativePlacesMinutes;
    }

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

    return [slices, places];
  }

//  static List<List<Slice>> aggregateLocationsInSlices2(
//      List<bg.Location> locations,
//      {List<Slice> partialDaySlices = const [],
//      List<Slice> partialDayPlaces = const []}) {
//    if (locations.isEmpty) return [[], []];
//
//    final currentDay = DateTime.tryParse(locations.first.timestamp).toLocal();
//
//    final List<Slice> slices = [];
//    final List<Slice> places = [];
//
//    Action lastAction = Action.Unknown;
//    bool isFirstGeofence = true;
//    String lastWhere;
//    slices.addAll(partialDaySlices);
//    places.addAll(partialDayPlaces);
//
//    final maxMinutes = 1440;
//    int cumulativeMinutes = partialDaySlices.isNotEmpty
//        ? partialDaySlices.last.startTime.toMinutes() +
//            partialDaySlices.last.minutes
//        : 0;
//
//    int cumulativePlacesMinutes = partialDayPlaces.isNotEmpty
//        ? partialDayPlaces.last.startTime.toMinutes() +
//            partialDayPlaces.last.minutes
//        : 0;
//
//    for (bg.Location loc in locations) {
//      final currentDate = DateTime.tryParse(loc.timestamp).toLocal();
//      final currentMinutes = currentDate.toMinutes();
//      final partialMinutes = currentMinutes - cumulativeMinutes;
//      final currentActivity = getActivityFromString(loc.activity.type);
//
//      int partialPlaceMinutes = currentMinutes - cumulativePlacesMinutes;
//
//      //gofence data
//      final geofence = loc.geofence;
//      final action = geofence?.action == null
//          ? Action.Unknown
//          : geofence?.action == 'EXIT' ? Action.Exit : Action.Enter;
//      final where = geofence?.identifier;
//      print('uuid: ${loc.uuid}, identifier: $where, action: $action');
//
//      //se places è vuoto aggiungo slice con place nullo o meno in base al geofence se exit o action
//      if (places.isEmpty) {
//        places.add(
//          Slice(
//            id: 0,
//            minutes: partialPlaceMinutes,
//            startTime: currentDate.withoutMinAndSec(),
//            places: action == Action.Unknown ? {} : {where},
//            activity: action == Action.Unknown
//                ? currentActivity
//                : MotionActivity.Still,
//            placeRecords: 1,
//          ),
//        );
//      } else if (loc.geofence == null) {
//        places.last.minutes += partialPlaceMinutes;
//        if (lastAction == Action.Enter) {
//          //ultima azione = Enter
//          places.last.placeRecords += 1;
//        } else if (lastAction == Action.Unknown) {
//          //ultima azione = Unknown
//          if (places.last.places.isEmpty) {
//            if (places.last.activity == currentActivity ||
//                places.last.activity == MotionActivity.Unknown) {
//              places.last.placeRecords += 1;
//            } else {
//              places.add(
//                Slice(
//                  id: 0,
//                  minutes: 0,
//                  activity: currentActivity,
//                  startTime: currentDate,
//                  places: {},
//                  placeRecords: 1,
//                ),
//              );
//            }
//          } else {
//            places.last.placeRecords += 1;
//          }
//        } else {
//          // ultima azione = EXIT
//          Set<String> newPlaces = Set.from(places.last.places);
//          if (newPlaces.contains(lastWhere)) {
//            newPlaces.remove(lastWhere);
//          }
//          if (places.last.places.isEmpty) {
//            if (places.last.activity == currentActivity ||
//                places.last.activity == MotionActivity.Unknown) {
//              places.last.activity = currentActivity;
//              places.last.placeRecords += 1;
//            } else {
//              places.add(
//                Slice(
//                  id: 0,
//                  minutes: 0,
//                  startTime: currentDate,
//                  places: newPlaces,
//                  activity: currentActivity,
//                  placeRecords: 1,
//                ),
//              );
//            }
//          } else {
//            places.last.placeRecords += 1;
//          }
//        }
//      } else {
//        //Geofence presente
//        places.last.minutes += partialPlaceMinutes;
//
//        if (action == Action.Enter) {
//          if (!places.last.places.contains(where)) {
//            Set<String> newPlaces = Set.from(places.last.places);
//            newPlaces.add(where);
//            places.add(
//              Slice(
//                id: 0,
//                minutes: 0,
//                startTime: currentDate,
//                places: newPlaces,
//                activity: MotionActivity.Still,
//                placeRecords: 1,
//              ),
//            );
//          } else {
//            places.last.placeRecords += 1;
//          }
//        } else if (action == Action.Exit) {
//          places.last.placeRecords += 1;
//          //situazione di primo EXIT della giornata visto che ol luogo non è contenuto nel precedente spicchio
//          if (isFirstGeofence) {
//            places.last.places.add(where);
//          }
//          //TODO potrebbe anche uscire da 2 posti di fila
//
//          Set<String> newPlaces = Set.from(places.last.places);
//          if (newPlaces.contains(where)) {
//            newPlaces.remove(where);
//          }
//
//          places.add(
//            Slice(
//              id: 0,
//              minutes: 0,
//              startTime: currentDate,
//              places: newPlaces,
//              activity: newPlaces.isEmpty
//                  ? MotionActivity.Unknown
//                  : MotionActivity.Still,
//              placeRecords: 0,
//            ),
//          );
//        }
//        isFirstGeofence = false;
//      }
//
//      lastAction = action;
//      lastWhere = where;
//      cumulativePlacesMinutes = currentMinutes;
//
//      if (slices.isEmpty) {
//        slices.add(
//          Slice(
//            id: 0,
//            minutes: partialMinutes,
//            activity: MotionActivity.Still,
//            startTime: currentDate.withoutMinAndSec(),
//          ),
//        );
//      } else if (slices.last.activity == currentActivity) {
//        slices.last.minutes += partialMinutes;
//      } else {
//        slices.last.minutes += partialMinutes;
//        slices.add(
//          Slice(
//            id: 0,
//            minutes: 0,
//            activity: currentActivity,
//            startTime: currentDate,
//          ),
//        );
//      }
//      cumulativeMinutes = currentMinutes;
//    }
//
//    print('cumulative minutes before last = $cumulativeMinutes');
//
//    if (cumulativePlacesMinutes < maxMinutes) {
//      if (currentDay.isToday()) {
//        places.add(
//          Slice(
//            id: 0,
//            minutes: maxMinutes - cumulativePlacesMinutes,
//            startTime: places.last.endTime,
//            places: {},
//          ),
//        );
//      } else {
//        places.last.minutes = maxMinutes - cumulativePlacesMinutes;
//      }
//      cumulativePlacesMinutes += maxMinutes - cumulativePlacesMinutes;
//    }
//
//    if (cumulativeMinutes < maxMinutes) {
//      if (currentDay.isToday()) {
//        slices.add(
//          Slice(
//            id: 0,
//            minutes: maxMinutes - cumulativeMinutes,
//            activity: MotionActivity.Unknown,
//            startTime: slices.last.endTime,
//          ),
//        );
//      } else {
//        slices.last.minutes = maxMinutes - cumulativeMinutes;
//      }
//      cumulativeMinutes += maxMinutes - cumulativeMinutes;
//    }
//
//    print('cumulative minutes complete = $cumulativeMinutes');
//
//    return [slices, places];
//  }

  static List<Slice> buildOnOffSlices(Map<String, bool> box,
      {List<Slice> slices = const []}) {
    final maxMinutes = 1440;
    final output = <Slice>[];
    final keys = box.keys.toList();
    final List<bool> values = box.values.toList();
    for (int i = 0; i < keys.length; i++) {
      final date = DateTime.tryParse(keys[i]);
      if (i == 0 && values[i]) {
        final minutes = date.toMinutes();
        output.add(
          Slice(
            startTime: date.withoutMinAndSec(),
            minutes: minutes,
            activity: MotionActivity.Off,
          ),
        );
      } else if (i == keys.length - 1 && !values[i]) {
        final minutes = maxMinutes - date.toMinutes();
        output.add(
          Slice(
            startTime: date,
            minutes: minutes,
            activity: MotionActivity.Off,
          ),
        );
      } else if (!values[i] && values[i + 1]) {
        final nextDate = DateTime.tryParse(keys[i + 1]);
        final minutes = nextDate.toMinutes() - date.toMinutes();
        output.add(
          Slice(
            startTime: date,
            minutes: minutes,
            activity: MotionActivity.Off,
          ),
        );
        i++;
      }
    }
    output.addAll(slices);
    output.sort((a, b) => a.startTime.compareTo(b.startTime));
    return output;
  }

  static List<Slice> reduceOnOff(List<Slice> slices) {
    int i = 0;
    final output = <Slice>[];
    final list = <Slice>[];

    if (slices.isEmpty) {
      return output;
    }
    if (slices.first.activity != MotionActivity.Off) {
      output.add(slices.first);
      final x = reduceOnOff(slices.sublist(1));
      output.addAll(x);
      return output;
    }

    while (i < slices.length && slices[i].activity == MotionActivity.Off) {
      list.add(slices[i]);
      i++;
    }

    Slice slice = list.reduce((Slice a, Slice b) => Slice(
          minutes: a.minutes + b.minutes,
          startTime: list.first.startTime,
          activity: a.activity,
        ));

    output.add(slice);
    if (i < slices.length) {
      output.addAll(reduceOnOff(slices.sublist(i)));
    }
    return output;
  }

  static insertFakeLocationInDb() async {
    final map = <String, dynamic>{
      "event": "geofence",
      "is_moving": false,
      "uuid": "a6f77fd0-7438-11ea-cde6-3530e872af08",
      "timestamp": "2020-04-01T17:01:04.000Z",
      "odometer": 0,
      "coords": {
        "latitude": 42.8126475,
        "longitude": 13.7261683,
        "accuracy": 15,
        "speed": 0,
        "heading": 257.03,
        "altitude": 287.7
      },
      "activity": {"type": "still", "confidence": 100},
      "battery": {"is_charging": true, "level": 0.66},
      "geofence": {
        "identifier": "CASA",
        "action": "ENTER",
        "extras": {
          "center": {"latitude": 42.8126787, "longitude": 13.726352899999995},
          "radius": 20
        }
      },
      "extras": {}
    };

    try {
      final location = await bg.BackgroundGeolocation.insertLocation(map);
      print(location);
    } catch (ex) {
      print(ex);
    }
  }

  static insertExitFromGeofenceOnDb(String identifier, DateTime dateTime,
      double latitude, double longitude, double radius) async {
    final map = <String, dynamic>{
      "event": "geofence",
      "is_moving": false,
      "uuid": Uuid().v1(),
      "timestamp": dateTime.toUtc().toIso8601String(),
      "odometer": 0,
      "coords": {
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": 0,
        "speed": 0,
        "heading": 0,
        "altitude": 0.0
      },
      "activity": {},
      "battery": {},
      "geofence": {
        "identifier": identifier,
        "action": "EXIT",
        "extras": {
          "center": {"latitude": latitude, "longitude": longitude},
          "radius": radius
        }
      },
      "extras": {}
    };

    try {
      final location = await bg.BackgroundGeolocation.insertLocation(map);
      print(location);
    } catch (ex) {
      print(ex);
    }
  }

  static insertOnOffOnDb(DateTime dateTime, bool enabled) async {
    final map = <String, dynamic>{
      "event": enabled ? 'ON' : 'OFF',
      "is_moving": false,
      "uuid": Uuid().v1(),
      "timestamp": dateTime.toUtc().toIso8601String(),
      "odometer": 0,
      "coords": {
        "latitude": 0.0,
        "longitude": 0.0,
        "accuracy": 0,
        "speed": 0,
        "heading": 0,
        "altitude": 0.0
      },
      "activity": {},
      "battery": {},
      "extras": {
        'enabled': enabled,
      }
    };

    try {
      final location = await bg.BackgroundGeolocation.insertLocation(map);
      print(location);
    } catch (ex) {
      print(ex);
    }
  }
}
