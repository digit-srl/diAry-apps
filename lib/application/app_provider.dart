import 'package:diary/utils/colors.dart';
import 'package:diary/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:diary/application/service_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class AppProvider with LocatorMixin {
  final ServiceNotifier serviceNotifier;

  AppProvider(this.serviceNotifier) {
    logger.i('AppProvider()');
    _initPlatformState();
//    _readLocations();
  }

  Future<Null> _initPlatformState() async {
    logger.i('init platform state');
//    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
//    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
//    bg.BackgroundGeolocation.onHeartbeat(_onHeartbeat);
//    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
//    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);

    bg.BackgroundGeolocation.ready(bg.Config(
            reset: false,
            debug: !kReleaseMode,
            persistMode: bg.Config.PERSIST_MODE_ALL,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 30.0,
            stopTimeout: 1,
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: false,
            maxDaysToPersist: 30,
            stationaryRadius: 25,
            preventSuspend: true,
            notification: bg.Notification(
                priority:
                    -2, // bassa priorità: l'icona risulta meno invasiva (ridotta, quando possibile)
                title: "Funzione di tracciamento attivata",
                text: "L'app lavorerà in background senza disturbarti!",
                smallIcon:
                    "mipmap/notification_icon", // <-- defaults to app icon
                largeIcon: "mipmap/notification_icon")))
        .then((bg.State state) {
      logger.i("[ready] ${state.toMap()}");
      logger.i(state.enabled);
      serviceNotifier.setEnabled(state.enabled);
//      read<ServiceNotifier>().setEnabled(state.enabled);
//      isMoving = state.isMoving;
    }).catchError((error) {
      logger.e('[ready] ERROR: $error');
    });
  }
}
