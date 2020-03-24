import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

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

  addGeofence() {}

  void _onGeofence(bg.GeofenceEvent geofenceEvent) {
    state = GeofenceEventState(geofenceEvent);
  }
}
