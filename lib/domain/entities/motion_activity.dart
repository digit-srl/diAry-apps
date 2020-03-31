import 'package:flutter/material.dart';

enum MotionActivity {
  Inactive,
  Still,
  OnFoot,
  Walking,
  Running,
  OnBicycle,
  InVehicle,
  Unknown,
  Off,
}

MotionActivity getActivityFromString(String activity) {
  switch (activity) {
    case 'still':
      return MotionActivity.Still;
    case 'on_foot':
      return MotionActivity.OnFoot;
    case 'walking':
      return MotionActivity.Walking;
    case 'running':
      return MotionActivity.Running;
    case 'on_bicycle':
      return MotionActivity.OnBicycle;
    case 'in_vehicle':
      return MotionActivity.InVehicle;
    default:
      return MotionActivity.Inactive;
  }
}

Color activityToColor(MotionActivity activity) {
  switch (activity) {
    case MotionActivity.Inactive:
      return Colors.black;
    case MotionActivity.Still:
      return Colors.grey;
    case MotionActivity.OnFoot:
      return Colors.lightBlueAccent;
    case MotionActivity.Walking:
      return Colors.pink;
    case MotionActivity.Running:
      return Colors.yellow;
    case MotionActivity.OnBicycle:
      return Colors.green;
    case MotionActivity.InVehicle:
      return Colors.red;
    default: //Activity.Unknown
      return Colors.transparent;
  }
}
