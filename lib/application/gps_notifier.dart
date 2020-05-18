import 'package:diary/utils/location_utils.dart';
import 'package:diary/utils/logger.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'location_notifier.dart';
import 'service_notifier.dart';

class GpsState {
  final bool gpsEnabled;
  final bool manualPositionDetection;
  GpsState(this.gpsEnabled, this.manualPositionDetection);
}

class GpsNotifier extends StateNotifier<GpsState> with LocatorMixin {
  GpsNotifier() : super(GpsState(false, false)) {
    bg.BackgroundGeolocation.onEnabledChange(_onEnabledChange);
    bg.BackgroundGeolocation.providerState.then((bg.ProviderChangeEvent event) {
      _onProviderChange(event);
      bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    });
  }

  _onEnabledChange(bool enabled) async {
    await Hive.box<String>('logs').add('[onEnabledChange] $enabled');
    final dateTime = DateTime.now();
    final location = await LocationUtils.insertOnOffOnDb(dateTime, enabled);
    read<LocationNotifier>().addLocation(location);
    read<ServiceNotifier>().setEnabled(enabled);
  }

  _onProviderChange(bg.ProviderChangeEvent event) {
    Hive.box<String>('logs').add('[onProviderChange] $event');
    if (state.gpsEnabled != event.gps) {
      state = GpsState(event.gps, false);
    }
  }

  getCurrentLoc(Function onDone, Function onError) {
    state = GpsState(state.gpsEnabled, true);
    LocationUtils.getCurrentLocationAndUpdateMap((bg.Location location) {
      logger.i('[getCurrentPosition] - $location');
      onDone(location);
      state = GpsState(state.gpsEnabled, false);
    }, (error) {
      logger.e('[getCurrentPosition] ERROR: $error');
      onError(error);
      state = GpsState(state.gpsEnabled, false);
    });
  }
}
