import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GeofenceChangeState {
  final bg.GeofencesChangeEvent geofencesChangeEvent;

  GeofenceChangeState(this.geofencesChangeEvent);
}

class GeofenceChangeNotifier extends StateNotifier<GeofenceChangeState>
    with LocatorMixin {
  GeofenceChangeNotifier() : super(GeofenceChangeState(null)) {
    bg.BackgroundGeolocation.onGeofencesChange(_onGeofencesChange);
  }

  void _onGeofencesChange(bg.GeofencesChangeEvent event) {
    state = GeofenceChangeState(event);
  }
}
