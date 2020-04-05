import 'package:diary/utils/location_utils.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:diary/utils/extensions.dart';
import 'day_notifier.dart';
import 'service_notifier.dart';

class GpsState {
  final bool gpsEnabled;

  GpsState(this.gpsEnabled);
}

class GpsNotifier extends StateNotifier<GpsState> with LocatorMixin {
  GpsNotifier() : super(GpsState(false)) {
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
    read<DayNotifier>().updateDay(location, dateTime.withoutMinAndSec());
    read<ServiceNotifier>().setEnabled(enabled);
  }

  _onProviderChange(bg.ProviderChangeEvent event) {
    Hive.box<String>('logs').add('[onProviderChange] $event');
    if (state.gpsEnabled != event.gps) {
      state = GpsState(event.gps);
    }
  }
}
