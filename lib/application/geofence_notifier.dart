import 'dart:ui' show Color;

import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GeofenceState {
  final List<ColoredGeofence> geofences;

  GeofenceState(this.geofences);
}

class GeofenceNotifier extends StateNotifier<GeofenceState> with LocatorMixin {
  GeofenceNotifier() : super(GeofenceState([])) {
    init();
  }

  init() async {
    final geofences = await bg.BackgroundGeolocation.geofences;
    final coloredGeofences = <ColoredGeofence>[];
    geofences.forEach((geofence) {
      final place = Hive.box<Place>('places').get(geofence.identifier);
      coloredGeofences.add(ColoredGeofence(geofence, Color(place.color)));
    });
    state = GeofenceState(coloredGeofences);
  }

  void addGeofence(bg.Geofence geofence, Color color) {
    final list = state.geofences;
    list.add(ColoredGeofence(geofence, color));
    state = GeofenceState(list);
  }

  void removeGeofence(String identifier) async {
    final success = await bg.BackgroundGeolocation.removeGeofence(identifier);
    if (success) {
      final place = Hive.box<Place>('places').get(identifier);
      place.enabled = false;
      place.save();
      final list = state.geofences;
      list.removeWhere((element) => element.geofence.identifier == identifier);
      state = GeofenceState(list);
    }
  }
}
