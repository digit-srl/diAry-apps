import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class ServiceState {
  ServiceState(this.isEnabled);

  final bool isEnabled;
}

class ServiceNotifier extends StateNotifier<ServiceState> with LocatorMixin {
  ServiceNotifier() : super(ServiceState(false));

  setEnabled(bool enabled) async {
    if (state.isEnabled != enabled) {
      state = ServiceState(enabled);
    }
  }

  invertEnabled() async {
    bg.State serviceState;
    if (state.isEnabled) {
      serviceState = await _disableService();
    } else {
      serviceState = await _enableService();
    }
//   state = ServiceState(serviceState.enabled);
  }

  Future<bg.State> _enableService() async {
    bg.State state = await bg.BackgroundGeolocation.state;
    if (state.trackingMode == 1) {
      return await bg.BackgroundGeolocation.start();
    } else {
      return await bg.BackgroundGeolocation.startGeofences();
    }
  }

  Future<bg.State> _disableService() async {
    return await bg.BackgroundGeolocation.stop();
  }
}
