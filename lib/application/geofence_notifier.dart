import 'dart:ui' show Color;

import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:flutter/material.dart' show Colors;
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
      final color = Hive.box<int>('geofences_color')
          .get(geofence.identifier, defaultValue: 65280);
      coloredGeofences.add(ColoredGeofence(geofence, Color(color)));
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
      Hive.box<int>('geofences_color').delete(identifier);
      final list = state.geofences;
      list.removeWhere((element) => element.geofence.identifier == identifier);
      state = GeofenceState(list);
    }
  }
}
