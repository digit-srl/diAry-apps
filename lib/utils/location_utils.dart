import 'package:dart_geohash/dart_geohash.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/domain/entities/slice.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'constants.dart';
import 'extensions.dart';
import '../domain/entities/day.dart';
import '../domain/entities/motion_activity.dart';
import 'dart:math';
import 'package:diary/main.dart';

import 'logger.dart';

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
    int i = 0;
    for (DateTime key in locationsPerDay.keys) {
      try {
        final yesterdayPlace = <String>{};
        if (i > 0 &&
            days[locationsPerDay.keys.toList()[i - 1]].places.isNotEmpty) {
          final oldPlaceIdentifiers =
              days[locationsPerDay.keys.toList()[i - 1]].places.last.places;
          yesterdayPlace.addAll(oldPlaceIdentifiers);
        }
        final tmp = aggregateLocationsInSlices3(
          date: key,
          locations: locationsPerDay[key],
          yesterdayPlaces: yesterdayPlace,
        );
        final dailyStatsResponse =
            Hive.box('dailyStatsResponse').get(key.toIso8601String());
        days[key] = tmp.copyWith(
          annotations: Hive.box<Annotation>('annotations')
                  .values
                  ?.where((annotation) => annotation.dateTime.isSameDay(key))
                  ?.toList() ??
              [],
        );
      } catch (ex) {
        Hive.box<String>('logs')
            .add('[LocationUtils] aggregateLocationsInDayPerDate $ex');
        analytics.logEvent(
            name: '[LocationUtils] ', parameters: {'error': ex.toString()});
        logger.e(ex);
      }
      i++;
    }
    return days;
  }

//  static Future<Map<DateTime, List<Location>>>
//      readAndFilterLocationsPerDay() async {
//    Map<DateTime, List<Location>> locationsPerDay = {};
//
//    List locationsMap = await bg.BackgroundGeolocation.locations;
//    logger('[LocationUtils] total records: ${locationsMap.length}');
//    final DateTime today = DateTime.now().withoutMinAndSec();
//    if (locationsMap.isEmpty) {
//      return {today: []};
//    }
//    for (var map in locationsMap) {
//      try {
//        final Location loc = Location.fromJson(Map<String, dynamic>.from(map));
//        final speed = loc?.coords?.speed ?? 0.0;
//        if (speed < 0.5) {
//          loc.activity.type = 'still';
//        }
//        final date = loc.dateTime.withoutMinAndSec();
//        if (!locationsPerDay.containsKey(date)) {
//          locationsPerDay[date] = [];
//        }
//        locationsPerDay[date].add(loc);
//      } catch (ex) {
//        logger('[ERROR] _readLocations \n$map\n$ex');
//        logger('[END_ERROR _readLocations');
//      }
//    }
//    return locationsPerDay;
//  }

//  Map<DateTime, bool> fakeActive = {
//    DateTime(2020, 3, 27, 17, 22): false,
//    DateTime(2020, 3, 27, 17, 25): true,
//  };

  static Day aggregateLocationsInSlices3({
    DateTime date,
    List<Location> locations,
    List<Slice> partialDaySlices,
    List<Slice> partialDayPlaces,
    Set<String> yesterdayPlaces,
  }) {
    if (locations.isEmpty) return Day(date: date);

    if (partialDaySlices == null) {
      partialDaySlices = [];
    }

    if (partialDayPlaces == null) {
      partialDayPlaces = [];
    }

    if (yesterdayPlaces == null) {
      yesterdayPlaces = {};
    }

    final currentDay = locations.first.dateTime;

    final List<Slice> slices = [];
    List<Slice> places = [];

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
//    final maxAccuracy =
//        Hive.box('user').get('aggregationAccuracy', defaultValue: kMaxAccuracy);
    final postProcessingEnabled =
        Hive.box('user').get('postProcessing', defaultValue: true);
    bool waitingOn = false;

    int discardedSampleCount = 0;
    int sampleCount = 0;
    int effectiveSampleCount = 0;
    double lat = 0.0;
    double long = 0.0;
    double minLat = 100;
    double maxLat = -100.0;
    double minLong = 200;
    double maxLong = -200.0;
    List<LatLng> coordinates = [];

    for (int i = 0; i < locations.length; i++) {
      sampleCount++;
      final Location loc = locations[i];
      final currentDate = loc.dateTime;
      final currentMinutes = currentDate.toMinutes();
      final partialMinutes = currentMinutes - cumulativeMinutes;
      final currentActivity = getActivityFromString(loc.activity.type);

      if (loc.coords.accuracy < kMaxAccuracy) {
        int partialPlaceMinutes = currentMinutes - cumulativePlacesMinutes;

        final event = loc.event;
        //gofence data
        final geofence = loc.geofence;
        final action = geofence?.action == null
            ? Action.Unknown
            : geofence?.action == 'EXIT' ? Action.Exit : Action.Enter;
        final where = geofence?.identifier;

        if (!(event == Event.On ||
            event == Event.Off ||
            (event == Event.Geofence &&
                loc.coords.latitude == 0.0 &&
                loc.coords.longitude == 0.0))) {
          final latitude = loc.coords.latitude;
          final longitude = loc.coords.longitude;
          lat += latitude;
          long += longitude;
          effectiveSampleCount++;
          coordinates.add(LatLng(latitude, longitude));
          if (latitude < minLat) {
            minLat = latitude;
          }
          if (latitude > maxLat) {
            maxLat = latitude;
          }

          if (longitude < minLong) {
            minLong = longitude;
          }

          if (longitude > maxLong) {
            maxLong = longitude;
          }
        }

        if (waitingOn) {
          if (event == Event.On) {
            final tmp = places.last.startTime.toMinutes();
            places.last.minutes = currentMinutes - tmp;
            waitingOn = false;
          }
        } else if (i == 0 && event == Event.On) {
          places.add(
            Slice(
              startTime:
                  partialDayPlaces.isEmpty ? currentDate.midnight : currentDate,
              minutes: partialPlaceMinutes,
              activity: MotionActivity.Off,
            ),
          );
        } else if (event == Event.Off) {
          //TODO controllare che places non sia vuoto o spostare casistica if (places.isEmpty) qui
          places.last.minutes += partialPlaceMinutes;
          if (places.last.activity != MotionActivity.Off) {
            places.add(
              Slice(
                startTime: currentDate,
                minutes: 0,
                activity: MotionActivity.Off,
              ),
            );
          }
          waitingOn = true;
//          cumulativePlacesMinutes += maxMinutes - currentMinutes;
          /*} else if (event == Event.Off) {
          places.last.minutes += partialPlaceMinutes;
//        final nextDate = locations[i + 1].dateTime;
//        final minutes = nextDate.toMinutes() - currentMinutes;
          places.add(
            Slice(
              startTime: currentDate,
              minutes: 0,
              activity: MotionActivity.Off,
            ),
          );
//        cumulativePlacesMinutes += minutes;
          waitingOn = true;
//        i++;*/
        } else if (places.isEmpty) {
          //se places è vuoto aggiungo slice con place nullo o meno in base al geofence se exit o action
          places.add(
            Slice(
              id: 0,
              minutes: partialPlaceMinutes,
              startTime: currentDate.midnight,
              places: action == Action.Enter
                  ? {where, ...yesterdayPlaces}
                  : yesterdayPlaces,
              activity: action == Action.Unknown
                  ? yesterdayPlaces.isEmpty
                      ? currentActivity
                      : MotionActivity.Still
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
            final newPlaces = Set<String>.from(places.last.places);
            if (newPlaces.contains(lastWhere)) {
              newPlaces.remove(lastWhere);
            }
            if (newPlaces.isEmpty) {
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
            if (places.isNotEmpty && !places.last.places.contains(where)) {
              if (lastAction == Action.Exit &&
                  places.last.activity == MotionActivity.Unknown) {
                places.last.places.add(where);
                places.last.activity = MotionActivity.Still;
                places.last.placeRecords += 1;
              } else {
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
              }
            } else {
              places.last.placeRecords += 1;
            }
          } else if (action == Action.Exit) {
            places.last.placeRecords += 1;
            //situazione di primo EXIT della giornata visto che ol luogo non è contenuto nel precedente spicchio
            if (isFirstGeofence && places.last.activity != MotionActivity.Off) {
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
      } else {
        discardedSampleCount++;
      }

      cumulativePlacesMinutes = currentMinutes;

      if (slices.isEmpty) {
        slices.add(
          Slice(
            id: 0,
            minutes: partialMinutes,
            activity: MotionActivity.Still,
            startTime: currentDate.midnight,
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

    logger.i('cumulative minutes before last = $cumulativeMinutes');

    if (cumulativePlacesMinutes < maxMinutes) {
      if (currentDay.isToday) {
        final nowMinutes = DateTime.now().toMinutes();
        final currentPartialTime = nowMinutes - cumulativePlacesMinutes;
        DateTime startTime;
        if (places.isNotEmpty) {
          places.last.minutes += currentPartialTime;
          startTime = places.last.endTime;
        }
        cumulativePlacesMinutes += currentPartialTime;
        places.add(
          Slice(
            id: 0,
            minutes: maxMinutes - cumulativePlacesMinutes,
            startTime: startTime ?? DateTime.now(),
            activity: MotionActivity.Unknown,
            places: {},
          ),
        );
      } else {
        if (places.isNotEmpty) {
          places.last.minutes += maxMinutes - cumulativePlacesMinutes;
        }
      }
      cumulativePlacesMinutes += maxMinutes - cumulativePlacesMinutes;
    }

    if (cumulativeMinutes < maxMinutes) {
      if (currentDay.isToday) {
        DateTime startTime = slices.last.endTime;
        slices.add(
          Slice(
            id: 0,
            minutes: maxMinutes - cumulativeMinutes,
            activity: MotionActivity.Unknown,
            startTime: startTime ?? DateTime.now(),
          ),
        );
      } else {
        if (slices.isNotEmpty) {
          slices.last.minutes += maxMinutes - cumulativeMinutes;
        }
      }
      cumulativeMinutes += maxMinutes - cumulativeMinutes;
    }

    logger.i('cumulative minutes complete = $cumulativeMinutes');

    if (postProcessingEnabled) {
      places.removeWhere((p) =>
          p.minutes == 0 &&
          p.activity == MotionActivity.Still &&
          p.places.isEmpty);

      places.forEach((p) {
        if (p.activity == MotionActivity.Still &&
            p.minutes < 2 &&
            p.places.isEmpty) {
          p.activity = MotionActivity.Walking;
        }
      });

      places = reduceWalking(places);
    }
    lat /= effectiveSampleCount;
    long /= effectiveSampleCount;

    String centroidHash = '00000';
    if (!(lat.isNaN || long.isNaN)) {
      centroidHash = getGeohash(lat, long);
      logger.i('$centroidHash');
    }
    double boundingBoxDiagonal = 0.0;

    if (effectiveSampleCount > 1) {
//      boundingBoxDiagonal =
//          sqrt(pow((maxLat - minLat), 2) + pow((maxLong - minLong), 2));

      boundingBoxDiagonal = distance(
          minLat: minLat, maxLat: maxLat, minLong: minLong, maxLong: maxLong);
    }

    final data = Day(
      date: date,
      slices: slices,
      places: places,
      centroidHash: centroidHash,
      effectiveSampleCount: effectiveSampleCount + discardedSampleCount,
      sampleCount: sampleCount,
      discardedSampleCount: discardedSampleCount,
      boundingBoxDiagonal: boundingBoxDiagonal,
    );
    return data;
  }

  static double distance(
      {double minLat, double minLong, double maxLat, double maxLong}) {
    try {
      final minLatRad = toRadians(minLat);
      final minLonRad = toRadians(minLong);
      final maxLatRad = toRadians(maxLat);
      final maxLonRad = toRadians(maxLong);
      double radius = 6371;

      double dist = acos(sin(minLatRad) * sin(maxLatRad) +
              cos(minLatRad) * cos(maxLatRad) * cos(maxLonRad - minLonRad)) *
          radius;

      return dist * 1000;
    } catch (ex) {
      return 0.0;
    }
  }

  static double toRadians(double degree) {
    double oneDeg = (pi) / 180;
    return (oneDeg * degree);
  }

  static String getGeohash(double lat, double long, {int precision = 5}) {
    // Separately you can use only the Geohasher functions
    GeoHasher geoHasher = GeoHasher();
    return geoHasher.encode(long, lat,
        precision: precision); // Returns a string geohash
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

  static List<Slice> reduceWalking(List<Slice> slices) {
    int i = 0;
    final output = <Slice>[];
    final list = <Slice>[];

    if (slices.isEmpty) {
      return output;
    }
    if (slices.first.activity != MotionActivity.Walking) {
      output.add(slices.first);
      final x = reduceWalking(slices.sublist(1));
      output.addAll(x);
      return output;
    }

    while (i < slices.length && slices[i].activity == MotionActivity.Walking) {
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
      output.addAll(reduceWalking(slices.sublist(i)));
    }
    return output;
  }

  static Future<Location> insertExitFromGeofenceOnDb(
    String identifier,
    DateTime dateTime,
  ) async {
    final map = <String, dynamic>{
      "event": "geofence",
      "is_moving": false,
      "uuid": Uuid().v1(),
      "timestamp": dateTime.toUtc().toIso8601String(),
      "odometer": 0.0,
      "coords": {
        "latitude": 0.0,
        "longitude": 0.0,
        "accuracy": 0.0,
        "speed": 0.0,
        "heading": 0.0,
        "altitude": 0.0
      },
      "activity": {},
      "battery": {},
      "geofence": {
        "identifier": identifier,
        "action": "EXIT",
        "extras": {
          "center": {"latitude": 0.0, "longitude": 0.0},
          "radius": 0.0
        }
      },
      "extras": {}
    };

    try {
      await bg.BackgroundGeolocation.insertLocation(map);
      logger.i('[EXIT] location inserted');
    } catch (ex) {
      logger.e('[EXIT] $ex');
    }
    logger.i('[EXIT] return location');
    return Location.fromJson(map);
  }

  static Future<Location> insertOnOffOnDb(
      DateTime dateTime, bool enabled) async {
    final Map<String, dynamic> map = <String, dynamic>{
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
      await bg.BackgroundGeolocation.insertLocation(map);
      logger.i('[ON/OFF] location inserted');
    } catch (ex) {
      logger.e('[ON/OFF] $ex');
    }
    logger.i('[ON/OFF] return location');
    return Location.fromJson(map);
  }
}

//class AggregationData {
//  final List<Slice> slices;
//  final List<Slice> places;
//  final String centroidHash;
//  final int discardedSampleCount;
//  final int sampleCount;
//  final LatLngBounds bounds;
//  final double boundingBoxDiagonal;
//
//  AggregationData({
//    this.slices = const [],
//    this.places = const [],
//    this.centroidHash,
//    this.discardedSampleCount,
//    this.sampleCount,
//    this.bounds,
//    this.boundingBoxDiagonal,
//  });
//}
