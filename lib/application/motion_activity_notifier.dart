import 'package:diary/domain/entities/motion_activity.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class MotionActivityState {
  MotionActivityState(this.activity);

  final MotionActivity activity;
}

class MotionActivityNotifier extends StateNotifier<MotionActivityState>
    with LocatorMixin {
  MotionActivityNotifier()
      : super(MotionActivityState(MotionActivity.Unknown)) {
    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
  }

  changeActivity(MotionActivity motionActivity) {
    state = MotionActivityState(motionActivity);
  }

  _onActivityChange(bg.ActivityChangeEvent event) {
    Hive.box<String>('logs').add('[onActivityChange] $event');
    changeActivity(getActivityFromString(event.activity));
  }
}
