import 'dart:async';

import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/place_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:diary/application/geofence_event_notifier.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/application/service_notifier.dart';
import 'package:provider/provider.dart';
import 'widgets/geofence_marker.dart';
import 'package:diary/utils/extensions.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>
    with AutomaticKeepAliveClientMixin<MapPage> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  BitmapDescriptor _currentPositionMarkerIcon;
  BitmapDescriptor _annotationPositionMarkerIcon;
  BitmapDescriptor _pinPositionMarkerIcon;

  Function removeServiceListener;
  Function removeLocationListener;
  Function removeDateListener;
  Function removeGeofenceListener;
  Function removeGeofenceEventListener;
  Function removeGeofenceChangeListener;

  DateTime _currentDate = DateTime.now().withoutMinAndSec();
  String log = "";
  Completer<GoogleMapController> _controller = Completer();
  Set<Circle> circles = {};
  Set<Circle> _allCircles = {};
  Set<GeofenceMarker> _geofences = {};
  Set<Marker> _currentPosition = {};

//  Set<Marker> _annotations = {};
//  bg.Location _stationaryLocation;
//  List<GeofenceMarker> _geofenceEvents = [];

  Set<Circle> _geofenceEventEdges = {};
  Set<Circle> _geofenceEventLocations = {};
  Set<Circle> _stationaryMarker = {};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();
    final todayLocations = Provider.of<LocationNotifier>(context, listen: false)
        .locationsPerDate[DateTime.now().withoutMinAndSec()];
    if (todayLocations?.isNotEmpty ?? false) {
      print('[MapPage] initState() todayLocations.isNotEmpty');
      final ll = LatLng(todayLocations.last.coords.latitude,
          todayLocations.last.coords.longitude);
      _initialPosition = CameraPosition(
        target: ll,
        zoom: 16,
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    removeLocationListener = Provider.of<LocationNotifier>(context).addListener(
      (state) {
        print('[MapPage] LocationNotifier');
        if (state.newLocation != null && _currentDate.isToday()) {
          _onLocation(state.newLocation);
        }
//        if (_currentDay.isToday()) {
//          for (int i = 0; i < state.liveLocations.length; i++) {
//            _locations.add(CircleMarker(
//                point: LatLng(
//                    50.1 + Random().nextInt(9), 0.0 + Random().nextInt(9)),
//                color: Colors.black,
//                radius: 5.0));
//          }
//        }
      },
    );

    removeGeofenceEventListener =
        Provider.of<GeofenceEventNotifier>(context).addListener(
      (state) {
        print('[MapPage] GeofenceEventNotifier');
        if (state.geofenceEvent != null) {
          _onGeofenceEvent(state.geofenceEvent);
        }
      },
    );

    removeGeofenceListener = Provider.of<GeofenceNotifier>(context).addListener(
      (state) {
        print('[MapPage] GeofenceNotifier');
        _onGeofence(state.geofences);
      },
    );

//    removeGeofenceChangeListener =
//        Provider.of<GeofenceChangeNotifier>(context).addListener(
//      (state) {
//        print('[MapPage] GeofenceChangeNotifier');
//        if (state.geofencesChangeEvent != null && _currentDate.isToday()) {
//          _onGeofencesChange(state.geofencesChangeEvent);
//        }
//      },
//    );

    removeServiceListener = Provider.of<ServiceNotifier>(context).addListener(
      (state) {
        print('[MapPage] ServiceNotifier');
        print(state.isEnabled);
      },
    );

    removeDateListener = Provider.of<DateNotifier>(context).addListener(
      (state) {
        print('[MapPage] DateNotifier');

        if (_currentDate != state.selectedDate) {
          _currentDate = state.selectedDate;
          _loadInitialDailyMarkers();
        }
      },
    );
  }

  void _onLocation(Location location) {
    print('[MapPage] [onLocation]');
    LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);
    _goToLocation(ll);
    _updateCurrentPositionMarker(ll);

    if (location.sample ?? false) {
      return;
    }
    addMarker(location);
//    circles.add(
//      Circle(
//          circleId: CircleId(location.uuid),
//          center: ll,
//          fillColor: Colors.black,
//          radius: 2),
//    );
//    setState(() {
//      updateAllCircles();
//    });
  }

  _onGeofenceTap(ColoredGeofence coloredGeofence) {
    print('[MapPage] _onGeofenceTap');
//    final color = Color(coloredGeofence.color);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.person_pin,
                        size: 35,
                        color: coloredGeofence.color,
                      ),
                    ),
                    Text(
                      coloredGeofence.name,
                      style: TextStyle(fontSize: 30),
                    ),
//                    coloredGeofence.isHome
//                        ? Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Icon(
//                              Icons.person_pin,
//                              size: 35,
//                              color: color,
//                            ),
//                          )
//                        : Container(),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.settings_ethernet,
                        color: coloredGeofence.color,
                      ),
                    ),
                    Text(
                        'Raggio: ${coloredGeofence.geofence.radius.toInt()} metri'),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      GenericButton(
                        text: 'Elimina',
                        onPressed: () async {
                          final deleted = await PlaceUtils.removePlace(
                              context, coloredGeofence.geofence.identifier);
                          if (deleted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
//                      GenericButton(
//                        text: 'Modifica',
//                        onPressed: () {},
//                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _onGeofence(List<ColoredGeofence> geofences) {
    _geofences.clear();
    try {
      geofences.forEach((ColoredGeofence coloredGeofence) {
        final geofenceMarker = GeofenceMarker(coloredGeofence, _onGeofenceTap);
        print(
            '[MapPage] _onGeofence add identifier ${coloredGeofence.geofence.identifier}');
        print('[MapPage] _onGeofence color ${geofenceMarker.fillColor}');
        _geofences.add(geofenceMarker);
      });
    } catch (ex) {
      print('[MapPage] _onGeofence error $ex');
    }
    setState(() {
      updateAllCircles();
    });
  }

  void _onGeofenceEvent(bg.GeofenceEvent event) {
    print('[MapPage] [_onGeofenceEvent]');
    GeofenceMarker marker = _geofences.firstWhere(
        (GeofenceMarker marker) =>
            marker.coloredGeofence.geofence.identifier == event.identifier,
        orElse: () => null);
    if (marker == null) {
      print(
          "[_onGeofence] failed to find geofence marker: ${event.identifier}");
      return;
    }

    if (marker == null) {
      print(
          '[onGeofence] WARNING - FAILED TO FIND GEOFENCE MARKER FOR GEOFENCE: ${event.identifier}');
      return;
    }

//    bg.Geofence geofence = marker.geofence;
//
//    // Render a new greyed-out geofence CircleMarker to show it's been fired but only if it hasn't been drawn yet.
//    // since we can have multiple hits on the same geofence.  No point re-drawing the same hit circle twice.
//    GeofenceMarker eventMarker = _geofenceEvents.firstWhere(
//        (GeofenceMarker marker) =>
//            marker.geofence.identifier == event.identifier,
//        orElse: () => null);
//    if (eventMarker == null)
//      _geofenceEvents.add(GeofenceMarker(geofence, true));
//
//    // Build geofence hit statistic markers:
//    // 1.  A computed CircleMarker upon the edge of the geofence circle (red=exit, green=enter)
//    // 2.  A CircleMarker for the actual location of the geofence event.
//    // 3.  A black PolyLine joining the two above.
    bg.Location location = event.location;
//    LatLng center = new LatLng(geofence.latitude, geofence.longitude);
    LatLng hit =
        new LatLng(location.coords.latitude, location.coords.longitude);

    // Update current position marker.
    _updateCurrentPositionMarker(hit);

//    // Determine bearing from center -> event location
//    double bearing = Geospatial.getBearing(center, hit);
//    // Compute a coordinate at the intersection of the line joining center point -> event location and the circle.
//    LatLng edge =
//        Geospatial.computeOffsetCoordinate(center, geofence.radius, bearing);
    // Green for ENTER, Red for EXIT.
//    Color color = Colors.green;
//    if (event.action == "EXIT") {
//      color = Colors.red;
//    } else if (event.action == "DWELL") {
//      color = Colors.yellow;
//    }

//    _geofenceEventEdges.add(
//      Circle(
//          circleId: CircleId(Random().nextInt(1000).toString()),
//          center: edge,
//          fillColor: color,
//          radius: 4,
//          strokeWidth: 1),
//    );
//
//    // Event location CircleMarker (background: black, stroke doesn't work so stack 2 circles)
//    _geofenceEventLocations.add(
//      Circle(
//          circleId: CircleId(Random().nextInt(1000).toString()),
//          center: edge,
//          strokeColor: Colors.black,
//          fillColor: Colors.blue,
//          radius: 4,
//          strokeWidth: 2),
//    );

    setState(() => updateAllCircles());
  }

//  void _onGeofencesChange(bg.GeofencesChangeEvent event) {
//    print('[MapPage] [_onGeofencesChange]');
//    print('[${bg.Event.GEOFENCESCHANGE}] - $event');
//    event.off.forEach((String identifier) {
//      _geofences.removeWhere((GeofenceMarker marker) {
//        return marker.geofence.identifier == identifier;
//      });
//    });
//
//    event.on.forEach((bg.Geofence geofence) {
//      _geofences.add(GeofenceMarker(geofence));
//    });
//
//    if (event.off.isEmpty && event.on.isEmpty) {
//      _geofences.clear();
//    }
//
//    setState(() {
//      updateAllCircles();
//    });
//  }

  void addMarker(Location location, {double hue}) {
    final MarkerId markerId = MarkerId(location.uuid);
    final Marker marker = Marker(
      markerId: markerId,
      icon: _pinPositionMarkerIcon,
//          onTap: () => onMarkerTap(loc),
      position: LatLng(
        location.coords.latitude,
        location.coords.longitude,
      ),
    );
//    final Marker marker = Marker(
//      markerId: markerId,
//      icon: BitmapDescriptor.defaultMarkerWithHue(
//          hue ?? BitmapDescriptor.hueGreen),
//      position: LatLng(
//        loc.coords.latitude,
//        loc.coords.longitude,
//      ),
//      onTap: () => onMarkerTap(loc),
//    );
    markers[markerId] = marker;
//    _goToLocation(loc);
    setState(() {
      markers[markerId] = marker;
    });
  }

  void onMarkerTap(bg.Location loc) {}

  /// Update Big Blue current position dot.
  void _updateCurrentPositionMarker(LatLng ll) {
    _currentPosition.clear();
    final MarkerId markerId = MarkerId("current_position");
    markers[markerId] = Marker(
      markerId: MarkerId("current_position"),
      position: ll,
      icon: _currentPositionMarkerIcon,
    );
    setState(() {});
//    _currentPosition.add(Circle(
//        circleId: CircleId('center'),
//        center: ll,
//        fillColor: Colors.blue,
//        strokeColor: Colors.white,
//        strokeWidth: 3,
//        radius: 11));

//    setState(() {
//      updateAllCircles();
//    });
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_currentPositionMarkerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/my_position_pin.png')
          .then(_updateCurrentBitmap);
    }
    if (_annotationPositionMarkerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/annotation_pin.png')
          .then(_updateAnnotationBitmap);
    }

    if (_pinPositionMarkerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/black_circle_pin.png')
          .then(_updateBlackBitmap);
    }
  }

  void _updateCurrentBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _currentPositionMarkerIcon = bitmap;
    });
  }

  void _updateBlackBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _pinPositionMarkerIcon = bitmap;
    });
  }

  void _updateAnnotationBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _annotationPositionMarkerIcon = bitmap;
    });
  }

  Future<void> _goToLocation(LatLng loc) async {
    if (!mounted) return;
    final GoogleMapController controller = await _controller.future;
    try {
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 16,
            target: LatLng(
              loc.latitude,
              loc.longitude,
            ),
          ),
        ),
      );
    } catch (ex) {
      print('[MapPage] [Error] [_goToLocation]');
      print(ex);
    }
  }

  void updateAllCircles() {
    print('updateAllCircles');
    _allCircles.clear();
    _allCircles = _stationaryMarker
        .union(circles)
        .union(_geofences)
        .union(_geofenceEventEdges)
        .union(_geofenceEventLocations);
    print('_allCircles.length');
    print(_allCircles.length);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('[MapPage] build');
    _createMarkerImageFromAsset(context);
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition ?? _kGooglePlex,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
//        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _loadInitialDailyMarkers();
        },
        markers: Set<Marker>.of(markers.values),
        circles: _allCircles,
      ),
//      floatingActionButton: MainMenuButton(),
    );
  }

  _loadInitialDailyMarkers() {
    markers.clear();
    final dailyLocations = Provider.of<LocationNotifier>(context, listen: false)
        .locationsPerDate[_currentDate];
    if (dailyLocations?.isNotEmpty ?? false) {
      for (Location location in dailyLocations) {
//      final icon = boxNotes.containsKey(loc.uuid)
//          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)
//          : BitmapDescriptor.defaultMarker;
//        circles.add(
//          Circle(
//              circleId: CircleId(location.uuid),
//              center: LatLng(
//                location.coords.latitude,
//                location.coords.longitude,
//              ),
//              fillColor: Colors.black,
//              radius: 2),
//        );
//        final icon = BitmapDescriptor.defaultMarker;
        final MarkerId markerId = MarkerId(location.uuid);
        final Marker marker = Marker(
          markerId: markerId,
          icon: _pinPositionMarkerIcon,
//          onTap: () => onMarkerTap(loc),
          position: LatLng(
            location.coords.latitude,
            location.coords.longitude,
          ),
        );
        markers[markerId] = marker;
      }
      setState(() {
        updateAllCircles();
      });
    }

//    await _goToLocation(dailyLocations.first);
  }

  @override
  void dispose() {
    print('[MapPage] dispose()');
    removeServiceListener();
    removeDateListener();
    removeLocationListener();
    removeGeofenceListener();
    removeGeofenceEventListener();
    removeGeofenceChangeListener();
    super.dispose();
  }
}
