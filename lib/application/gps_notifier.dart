import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GpsState {
  final bool gpsEnabled;

  GpsState(this.gpsEnabled);
}

class GpsNotifier extends StateNotifier<GpsState> with LocatorMixin {
  GpsNotifier() : super(GpsState(false)) {
    bg.BackgroundGeolocation.providerState.then((bg.ProviderChangeEvent event) {
      _onProviderChange(event);
      bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    });
  }

  _onProviderChange(bg.ProviderChangeEvent event) {
    Hive.box<String>('logs').add('[onProviderChange] $event');
    if (state.gpsEnabled != event.gps) {
      state = GpsState(event.gps);
    }
  }
}
