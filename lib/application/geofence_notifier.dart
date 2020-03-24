import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GeofenceState {
  final List<bg.Geofence> geofences;

  GeofenceState(this.geofences);
}

class GeofenceNotifier extends StateNotifier<GeofenceState> with LocatorMixin {
  GeofenceNotifier() : super(GeofenceState([])) {
    init();
  }

  init() async {
    final geofences = await bg.BackgroundGeolocation.geofences;
    state = GeofenceState(geofences);
  }

  void addGeofence(bg.Geofence geofence) {
    final list = state.geofences;
    list.add(geofence);
    state = GeofenceState(list);
  }

  void removeGeofence(String identifier) async {
    final success = await bg.BackgroundGeolocation.removeGeofence(identifier);
    if (success) {
      final list = state.geofences;
      list.removeWhere((element) => element.identifier == identifier);
      state = GeofenceState(list);
    }
  }
}
