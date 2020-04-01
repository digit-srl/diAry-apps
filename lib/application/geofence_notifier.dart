import 'dart:ui' show Color;

import 'package:diary/application/day_notifier.dart';
import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:diary/infrastructure/user_repository.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:uuid/uuid.dart';
import 'package:diary/utils/extensions.dart';

class GeofenceState {
  final List<ColoredGeofence> geofences;

  GeofenceState(this.geofences);
}

class GeofenceNotifier extends StateNotifier<GeofenceState> with LocatorMixin {
  final UserRepositoryImpl userRepo;

  GeofenceNotifier(this.userRepo) : super(GeofenceState([])) {
    init();
  }

  init() async {
    final homeIdentifier = userRepo.getHomeGeofenceIdentifier();
    final geofences = await bg.BackgroundGeolocation.geofences;
    final places = <Place>[];
    final box = Hive.box<Place>('places');
    final list = <ColoredGeofence>[];
    bg.Geofence geofence;
    for (int i = 0; i < geofences.length; i++) {
      geofence = geofences[i];
      Place place;
      final identifier = geofence.identifier;
      final oldName = geofence.extras['name'];
      final oldColor = geofence.extras['color'];
      final isHome = geofence.extras['isHome'];
      try {
        if (box.containsKey(identifier)) {
          place = box.get(identifier);
        } else {
          final deleted =
              await bg.BackgroundGeolocation.removeGeofence(identifier);
          print('[GeofenceNotifier] deleted $identifier $oldName');
          if (deleted) {
            final newIdentifier = Uuid().v1();
            geofence = bg.Geofence(
              identifier: identifier,
              radius: geofence.radius,
              latitude: geofence.latitude,
              longitude: geofence.longitude,
              notifyOnEntry: true,
              notifyOnExit: true,
              extras: {
                'name': oldName ?? identifier,
                'color': oldColor ?? Colors.orange.value,
                'isHome': isHome ?? homeIdentifier == identifier,
                'radius': geofence.radius,
                'center': {
                  'latitude': geofence.latitude,
                  'longitude': geofence.longitude
                }
              },
            );
            final success =
                await bg.BackgroundGeolocation.addGeofence(geofence);
            if (success) {
              print(
                  '[GeofenceNotifier] created $newIdentifier $oldName $identifier');
              place = Place(
                  identifier,
                  oldName ?? identifier,
                  oldColor ?? Colors.orange.value,
                  isHome ?? homeIdentifier == identifier,
                  geofence.latitude,
                  geofence.longitude,
                  geofence.radius);
              box.put(identifier, place);
            }
          }
        }
        places.add(place);
        list.add(ColoredGeofence(geofence, Color(place.color), place.name));
        print('[GeofenceNotifier] added $oldName $identifier');
      } catch (ex) {
        print('[GeofenceNotifier] error: $ex');
      }
    }
    print('[GeofenceNotifier] updateState');
    state = GeofenceState(list);
  }

  void addGeofence(bg.Geofence geofence, Color color, String name) {
    final list = state.geofences;
    list.add(ColoredGeofence(geofence, color, name));
    state = GeofenceState(list);
  }

  void removeGeofence(String identifier) async {
    final deleted = await bg.BackgroundGeolocation.removeGeofence(identifier);
    if (deleted) {
      final location = await LocationUtils.insertExitFromGeofenceOnDb(
          identifier, DateTime.now(), 0.0, 0.0, 0.0);
      //TODO usare data della lcocation
      read<DayNotifier>()
          .updateDay(location, DateTime.now().withoutMinAndSec());
      final place = Hive.box<Place>('places').get(identifier);
      place.enabled = false;
      place.isHome = false;
      if (place.isHome) {
        userRepo.removeHomeGeofence();
      }
      place.save();
      final list = state.geofences;
      list.removeWhere((element) => element.geofence.identifier == identifier);
      state = GeofenceState(list);
    }
  }

  void editGeofence(String identifier,
      {String name,
      bool isHome,
      double latitude,
      double longitude,
      double radius,
      int color}) async {
    final place = Hive.box<Place>('places').get(identifier);
    final deleted = await bg.BackgroundGeolocation.removeGeofence(identifier);
    if (deleted) {
      final geofence = bg.Geofence(
        identifier: place.identifier,
        radius: radius ?? place.radius,
        latitude: latitude ?? place.latitude,
        longitude: longitude ?? place.longitude,
        notifyOnEntry: true,
        notifyOnExit: true,
        extras: {
          'name': name ?? place.name,
          'color': color ?? place.color,
          'isHome': isHome ?? place.isHome,
          'radius': radius ?? place.radius,
          'center': {
            'latitude': latitude ?? place.latitude,
            'longitude': longitude ?? place.longitude,
          }
        },
      );
      final added = await bg.BackgroundGeolocation.addGeofence(geofence);
      if (added) {
        if (name != null) {
          place.name = name;
        }
        if (radius != null) {
          place.radius = radius;
        }
        if (latitude != null) {
          place.latitude = latitude;
        }
        if (longitude != null) {
          place.longitude = longitude;
        }
        if (isHome != null) {
          if (!isHome &&
              place.identifier == userRepo.getHomeGeofenceIdentifier()) {
            userRepo.removeHomeGeofence();
          } else {
            userRepo.setHomeGeofenceIdentifier(identifier);
          }
          place.isHome = isHome;
        }
        if (color != null) {
          place.color = color;
        }
        place.save();
      }
    }
//    }
  }
}
