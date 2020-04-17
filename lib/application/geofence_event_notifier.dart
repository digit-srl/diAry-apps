import 'package:diary/domain/entities/location.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import '../main.dart';
import 'location_notifier.dart';

class GeofenceEventState {
  final bg.GeofenceEvent geofenceEvent;

  GeofenceEventState(this.geofenceEvent);
}

class GeofenceEventNotifier extends StateNotifier<GeofenceEventState>
    with LocatorMixin {
  List<bg.Geofence> geofences = [];

  GeofenceEventNotifier() : super(GeofenceEventState(null)) {
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
  }

  void _onGeofence(bg.GeofenceEvent geofenceEvent) {
    try {
      Hive.box<String>('logs').add('[onGeofence] $geofenceEvent');
      final location = Location.fromJson(
          Map<String, dynamic>.from(geofenceEvent.location.map));
      final event = Geofence.fromJson({
        'identifier': geofenceEvent.identifier,
        'action': geofenceEvent.action,
        'extras': geofenceEvent.extras,
      });
      location.geofence = event;
      print('[Geofence Location] location $location');
      if (location != null) {
        read<LocationNotifier>().addLocation(location);
      }
      state = GeofenceEventState(geofenceEvent);
    } catch (ex) {
      Hive.box<String>('logs').add(
          '[ERROR onGeofence] $ex, ${geofenceEvent ?? 'errore lettura GeofenceEvent'}');
      analytics.logEvent(
          name: '[GeofenceEventNotifier] _onGeofence',
          parameters: {'error': ex.toString()});
    }
  }
}
