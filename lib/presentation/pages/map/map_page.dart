import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/annotation_notifier.dart';
import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/application/root_elevation_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/presentation/widgets/custom_icons_icons.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/presentation/widgets/manual_detection_position_layer.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/place_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:diary/application/geofence_event_notifier.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/application/service_notifier.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import 'widgets/geofence_marker.dart';
import 'package:diary/utils/extensions.dart';
import 'package:intl/intl.dart';

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

  Function removeServiceListener;
  Function removeLocationListener;
  Function removeDateListener;
  Function removeGeofenceListener;
  Function removeGeofenceEventListener;
  Function removeGeofenceChangeListener;
  Function removeAnnotationListener;

  DateTime _currentDate = DateTime.now().withoutMinAndSec();
  DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');
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
  List<Annotation> annotations = [];

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
      Provider.of<RootElevationNotifier>(context, listen: false)
          .changeElevationIfDifferent(1, 4);
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

    removeAnnotationListener = context.read<AnnotationNotifier>().addListener(
      (state) {
        print('[MapPage] AnnotationNotifier');
        if (state != null && _currentDate.isToday()) {
          _onAnnotation(state);
        }
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
  }

  void _onGeofenceTap(ColoredGeofence coloredGeofence) {
    print('[MapPage] _onGeofenceTap');
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: coloredGeofence.color,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          //isHome ? CustomIcons.home_outline : CustomIcons.map_marker_outline,
                          CustomIcons.map_marker_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 16),
                          child: AutoSizeText(
                            "Luogo",
                            maxLines: 1,
                            style: TextStyle(fontSize: 30, color: accentColor),
                          )),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                      tooltip: "Modifica (coming soon!)",
                    ),
                    IconButton(
                        icon: Icon(CustomIcons.trash_can_outline),
                        tooltip: "Elimina",
                        onPressed: () async {
                          final deleted = await PlaceUtils.removePlace(
                              context, coloredGeofence.geofence.identifier);
                          if (deleted) {
                            Navigator.of(context).pop();
                          }
                        }),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.message,
                      ),
                    ),
                    Text(
                      "Nome del luogo: " + coloredGeofence.name,
                      style: TextStyle(color: secondaryText),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.settings_ethernet,
                        color: accentColor,
                      ),
                    ),
                    AutoSizeText(
                      'Raggio: ${coloredGeofence.geofence.radius.toInt()} metri',
                      maxLines: 1,
                      style: TextStyle(color: secondaryText),
                    ),
                  ],
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

    bg.Location location = event.location;
    LatLng hit =
        new LatLng(location.coords.latitude, location.coords.longitude);

    // Update current position marker.
    _updateCurrentPositionMarker(hit);
    setState(() => updateAllCircles());
  }

  void _onAnnotation(AnnotationState annotationState) {
    if (annotationState.action == AnnotationAction.Added) {
      addAnnotationMarker(annotationState.annotation);
    } else if (annotationState.action == AnnotationAction.Removed) {
      markers.removeWhere((k, v) => k.value == annotationState.annotation.id);
      setState(() {});
    }
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
      icon: pinPositionMarkerIcon,
      onTap: () => _onLocationTap(location),
      position: LatLng(
        location.coords.latitude,
        location.coords.longitude,
      ),
      zIndex: 0.1,
    );
    markers[markerId] = marker;
    setState(() {
      markers[markerId] = marker;
    });
  }

  void addAnnotationMarker(Annotation annotation) {
    final MarkerId markerId = MarkerId(annotation.id);
    final Marker marker = Marker(
      markerId: markerId,
      icon: annotationPositionMarkerIcon,
      onTap: () => _onAnnotationTap(annotation),
      position: LatLng(
        annotation.latitude,
        annotation.longitude,
      ),
      zIndex: 0.2,
    );
    markers[markerId] = marker;
    setState(() {
      markers[markerId] = marker;
    });
  }

  /// Update Big Blue current position dot.
  void _updateCurrentPositionMarker(LatLng ll) {
    _currentPosition.clear();
    final MarkerId markerId = MarkerId("current_position");
    markers[markerId] = Marker(
      markerId: MarkerId("current_position"),
      position: ll,
      icon: currentPositionMarkerIcon,
      zIndex: 0.3,
    );
    setState(() {});
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (currentPositionMarkerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/my_position_pin.png')
          .then(_updateCurrentBitmap);
    }
    if (annotationPositionMarkerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/annotation_pin.png')
          .then(_updateAnnotationBitmap);
    }

    if (pinPositionMarkerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/black_circle_pin.png')
          .then(_updateBlackBitmap);
    }

    if (selectedPinMarkerIcon == null) {
      final ImageConfiguration imageConfiguration = ImageConfiguration(
        bundle: DefaultAssetBundle.of(context),
        devicePixelRatio: 2.5,
        locale: Localizations.localeOf(context, nullOk: true),
        textDirection: Directionality.of(context),
        platform: defaultTargetPlatform,
      );
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/selected_pin.png')
          .then(_updateSelectedBitmap);
    }
  }

  void _updateCurrentBitmap(BitmapDescriptor bitmap) {
    setState(() {
      currentPositionMarkerIcon = bitmap;
    });
  }

  void _updateBlackBitmap(BitmapDescriptor bitmap) {
    setState(() {
      pinPositionMarkerIcon = bitmap;
    });
  }

  void _updateSelectedBitmap(BitmapDescriptor bitmap) {
    setState(() {
      selectedPinMarkerIcon = bitmap;
    });
  }

  void _updateAnnotationBitmap(BitmapDescriptor bitmap) {
    setState(() {
      annotationPositionMarkerIcon = bitmap;
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition ?? _kGooglePlex,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _loadInitialDailyMarkers();
            },
            markers: Set<Marker>.of(markers.values),
            circles: _allCircles,
          ),
          ManualDetectionPositionLayer(),
        ],
      ),
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
          icon: pinPositionMarkerIcon,
          onTap: () => _onLocationTap(location),
          position: LatLng(
            location.coords.latitude,
            location.coords.longitude,
          ),
          zIndex: 0.1,
        );
        markers[markerId] = marker;
      }
    }
    final annotations = context
        .read<AnnotationNotifier>()
        .annotations
        .where((a) => a.dateTime.isSameDay(_currentDate));
    if (annotations.isNotEmpty) {
      for (Annotation annotation in annotations) {
        final MarkerId markerId = MarkerId(annotation.id);
        final Marker marker = Marker(
          markerId: markerId,
          icon: annotationPositionMarkerIcon,
          onTap: () => _onAnnotationTap(annotation),
          position: LatLng(
            annotation.latitude,
            annotation.longitude,
          ),
          zIndex: 0.2,
        );
        markers[markerId] = marker;
      }
    }
    setState(() {});
  }

  _onLocationTap(Location location) async {
    print('[MapPage] _onLocationTap');

    final MarkerId markerId = MarkerId('${location.uuid}_tmp');
//    final MarkerId markerId = MarkerId('${location.uuid}');
    final Marker marker = Marker(
      markerId: markerId,
      icon: selectedPinMarkerIcon,
      anchor: Offset(0.5, 0.5),
      position: LatLng(
        location.coords.latitude,
        location.coords.longitude,
      ),
      zIndex: 0.4,
    );

    setState(() {
      markers[markerId] = marker;
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 300,
          child:
          Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        //isHome ? CustomIcons.home_outline : CustomIcons.map_marker_outline,
                        Icons.pin_drop,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AutoSizeText(
                          "Pin",
                          maxLines: 1,
                          style: TextStyle(fontSize: 30, color: accentColor),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(Icons.data_usage)),
                  Expanded(
                    child: AutoSizeText(
                      location.uuid,
                      maxLines: 1,
                      style: TextStyle(color: secondaryText),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(Icons.access_time)),
                  Expanded(
                    child: AutoSizeText(
                      dateFormat.format(location.dateTime),
                      maxLines: 1,
                      style: TextStyle(color: secondaryText),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                    child: Icon(
                      Icons.pin_drop,
                    ),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      'Lat: ${location.coords.latitude.toStringAsFixed(2)} Long: ${location.coords.longitude.toStringAsFixed(2)}',
                      style: TextStyle(color: secondaryText),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                    child: Icon(
                      Icons.gps_fixed,
                    ),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      'Accuratezza: ${location.coords.accuracy} m',
                      style: TextStyle(color: secondaryText),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                    child: Icon(
                      Icons.event,
                    ),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      'Evento: ${location.event.toString().replaceFirst('Event.', '')}',
                      style: TextStyle(color: secondaryText),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              if (location?.activity != null)
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.directions_walk,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        'Attività: ${location.activity.type.toUpperCase()} al ${location.activity.confidence.toInt()} %',
                        style: TextStyle(color: secondaryText),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              if (location?.battery != null)
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
                      child: Icon(
                        location.battery.isCharging
                            ? Icons.battery_charging_full
                            : Icons.battery_std,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        '${(location.battery.level * 100).toInt()} %',
                        style: TextStyle(color: secondaryText),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          ),
        );
      },
    );
    markers.removeWhere((k, v) => k.value == '${location.uuid}_tmp');
    setState(() {});
  }

  _onAnnotationTap(Annotation annotation) {
    print('[MapPage] _onAnnotationTap');
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          //isHome ? CustomIcons.home_outline : CustomIcons.map_marker_outline,
                          CustomIcons.bookmark_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AutoSizeText(
                            "Annotazione",
                            maxLines: 1,
                            style: TextStyle(fontSize: 30, color: accentColor),
                          )),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                      tooltip: "Modifica (coming soon!)",
                    ),
                    IconButton(
                      icon: Icon(CustomIcons.trash_can_outline),
                      tooltip: "Elimina",
                      onPressed: () async {
                        GenericUtils.ask(context,
                            'Sicuro di volere eliminare questa annotazione?',
                            () {
                          context
                              .read<AnnotationNotifier>()
                              .removeAnnotation(annotation);
                          Navigator.of(context).pop();
                        }, () {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.message,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        annotation.title,
                        style: TextStyle(color: secondaryText),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.gps_fixed,
                      ),
                    ),
                    Text(
                      'Lat: ${annotation.latitude.toStringAsFixed(2)} Long: ${annotation.longitude.toStringAsFixed(2)}',
                      style: TextStyle(color: secondaryText),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.access_time,
                      ),
                    ),
                    Text(
                      dateFormat.format(annotation.dateTime),
                      style: TextStyle(color: secondaryText),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
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
    removeAnnotationListener();
    super.dispose();
  }
}
