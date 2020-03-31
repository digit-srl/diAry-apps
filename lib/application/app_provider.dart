import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:diary/application/service_notifier.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';

class AppProvider with LocatorMixin {
  final ServiceNotifier serviceNotifier;

  AppProvider(this.serviceNotifier) {
    print('AppProvider()');
    _initPlatformState();
//    _readLocations();
  }

  Future<Null> _initPlatformState() async {
    print('init platform state');
//    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
//    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
//    bg.BackgroundGeolocation.onHeartbeat(_onHeartbeat);
//    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
//    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onEnabledChange(_onEnabledChange);

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
    )).then((bg.State state) {
      print("[ready] ${state.toMap()}");
      print(state.enabled);
      serviceNotifier.setEnabled(state.enabled);
//      read<ServiceNotifier>().setEnabled(state.enabled);
//      isMoving = state.isMoving;
    }).catchError((error) {
      print('[ready] ERROR: $error');
    });
  }

  _onEnabledChange(bool enabled) {
    Hive.box<String>('logs').add('[onEnabledChange] $enabled');
    final dateTime = DateTime.now().toIso8601String();
    Hive.box<bool>('enabled_change').put(dateTime, enabled);
    serviceNotifier.setEnabled(enabled, dateTime: dateTime);
  }
}
