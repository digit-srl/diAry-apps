import 'dart:ui' show Color;

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg show Geofence;

class ColoredGeofence {
  final bg.Geofence geofence;
  final Color color;

  ColoredGeofence(this.geofence, this.color);
}
