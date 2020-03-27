//import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//    as bg show Geofence;
//import 'package:latlong/latlong.dart';
//
//class GeofenceMarker extends CircleMarker {
//  bg.Geofence geofence;
//
//  GeofenceMarker(bg.Geofence geofence, [bool triggered = false])
//      : super(
//            useRadiusInMeter: true,
//            radius: geofence.radius,
//            color: (triggered)
//                ? Colors.black26.withOpacity(0.2)
//                : Colors.green.withOpacity(0.3),
//            point: LatLng(geofence.latitude, geofence.longitude)) {
//    this.geofence = geofence;
//  }
//}

import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg show Geofence;

class GeofenceMarker extends Circle {
  bg.Geofence geofence;

  GeofenceMarker(
    ColoredGeofence coloredGeofence,
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
    this.geofence = coloredGeofence.geofence;
  }
}
