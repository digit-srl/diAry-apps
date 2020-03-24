import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GpsState {
  final bool gpsEnabled;

  GpsState(this.gpsEnabled);
}

class GpsNotifier extends StateNotifier<GpsState> with LocatorMixin {
  GpsNotifier() : super(GpsState(false)) {
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
  }

  _onProviderChange(bg.ProviderChangeEvent event) {
    if (state.gpsEnabled != event.gps) {
      state = GpsState(event.gps);
    }
  }
}
