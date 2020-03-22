import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GeofenceState {
  final bg.GeofenceEvent geofenceEvent;

  GeofenceState(this.geofenceEvent);
}

class GeofenceNotifier extends StateNotifier<GeofenceState> with LocatorMixin {
  GeofenceNotifier() : super(GeofenceState(null)) {
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
  }

  void _onGeofence(bg.GeofenceEvent geofenceEvent) {
    state = GeofenceState(geofenceEvent);
  }
}
