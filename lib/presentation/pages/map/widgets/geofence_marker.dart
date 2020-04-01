import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeofenceMarker extends Circle {
  final ColoredGeofence coloredGeofence;
  GeofenceMarker(
    this.coloredGeofence,
    Function(ColoredGeofence) onTap, [
    bool triggered = false,
  ]) : super(
          circleId: CircleId(coloredGeofence.geofence.identifier),
          center: LatLng(coloredGeofence.geofence.latitude,
              coloredGeofence.geofence.longitude),
          radius: coloredGeofence.geofence.radius,
          strokeWidth: 0,
          fillColor: (triggered)
              ? Colors.black26.withOpacity(0.2)
              : coloredGeofence.color.withOpacity(0.3),
          consumeTapEvents: true,
          onTap: () {
            onTap(coloredGeofence);
          },
        ) {
//    this.geofence = coloredGeofence.geofence;
  }
}
