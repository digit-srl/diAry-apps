//import 'dart:math';
//
//import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong/latlong.dart';
//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//as bg show Location;
//import 'package:diary/application/location_notifier.dart';
//import 'package:diary/application/root/date_notifier.dart';
//import 'package:diary/application/service_notifier.dart';
//import 'package:provider/provider.dart';
//import 'geofence_view.dart';
//import 'widgets/geofence_marker.dart';
//import 'package:diary/extensions.dart';
//
//class MapPage extends StatefulWidget {
//  @override
//  _MapPageState createState() => _MapPageState();
//}
//
//class _MapPageState extends State<MapPage>
//    with AutomaticKeepAliveClientMixin<MapPage> {
//  @override
//  bool get wantKeepAlive {
//    return true;
//  }
//
//  Function removeServiceListener;
//  Function removeLocationListener;
//  Function removeDateListener;
//
//  bg.Location _stationaryLocation;
//
//  List<CircleMarker> _currentPosition = [];
//  List<CircleMarker> _locations = [];
//  List<CircleMarker> _stopLocations = [];
//  List<CircleMarker> _stationaryMarker = [];
//  List<GeofenceMarker> _geofences = [];
//  List<GeofenceMarker> _geofenceEvents = [];
//  List<CircleMarker> _geofenceEventEdges = [];
//  List<CircleMarker> _geofenceEventLocations = [];
//  DateTime _currentDay;
//  LatLng _center = LatLng(50.1, 0.0);
//  MapController _mapController;
//  MapOptions _mapOptions;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _currentDay = DateTime.now();
//    _mapOptions = MapOptions(
//        onPositionChanged: _onPositionChanged,
//        center: _center,
//        zoom: 16.0,
//        onLongPress: _onAddGeofence);
//    _mapController = new MapController();
//  }
//
//  void _onPositionChanged(MapPosition pos, bool hasGesture) {
//    _mapOptions.crs.scale(_mapController.zoom);
//  }
//
//  void _onAddGeofence(LatLng latLng) {
//    // TODO Play sound
//
//    Navigator.of(context).push(
//      MaterialPageRoute<Null>(
//        fullscreenDialog: true,
//        builder: (BuildContext context) {
//          return GeofenceView(latLng);
//        },
//      ),
//    );
//  }
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//
//    removeLocationListener = Provider.of<LocationNotifier>(context).addListener(
//          (state) {
//        print('[MapPage] LocationNotifier');
//
//        if (_currentDay.isToday()) {
//          for (int i = 0; i < state.liveLocations.length; i++) {
//            _locations.add(CircleMarker(
//                point: LatLng(
//                    50.1 + Random().nextInt(9), 0.0 + Random().nextInt(9)),
//                color: Colors.black,
//                radius: 5.0));
//          }
//        }
//      },
//    );
//
//    removeServiceListener = Provider.of<ServiceNotifier>(context).addListener(
//          (state) {
//        print('[MapPage] ServiceNotifier');
//        print(state.isEnabled);
//      },
//    );
//
//    removeDateListener = Provider.of<DateNotifier>(context).addListener(
//          (state) {
//        print('[MapPage] DateNotifier');
//        _currentDay = state.selectedDate;
//        _locations.clear();
//        final limit = Random().nextInt(20);
//        for (int i = 0; i < limit; i++) {
//          _locations.add(CircleMarker(
//              point:
//              LatLng(50.1 + Random().nextInt(9), 0.0 + Random().nextInt(9)),
//              color: Colors.red,
//              radius: 5.0));
//        }
//      },
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        body: FlutterMap(
//          mapController: _mapController,
//          options: _mapOptions,
//          layers: [
//            TileLayerOptions(
//              urlTemplate:
//              "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
//              subdomains: ['a', 'b', 'c'],
//            ),
//            MarkerLayerOptions(
//              markers: [
//                Marker(
//                  width: 80.0,
//                  height: 80.0,
//                  point: LatLng(51.5, -0.09),
//                  builder: (ctx) => Container(
//                    child: FlutterLogo(),
//                  ),
//                ),
//              ],
//            ),
//            // Active geofence circles
//            CircleLayerOptions(circles: _geofences),
//            // Big red stationary radius while in stationary state.
//            CircleLayerOptions(circles: _stationaryMarker),
//            // Recorded locations.
//            CircleLayerOptions(circles: _locations),
//            // Small, red circles showing where motionchange:false events fired.
//            CircleLayerOptions(circles: _stopLocations),
//            // Geofence events (edge marker, event location and polyline joining the two)
//            CircleLayerOptions(circles: _geofenceEvents),
//            CircleLayerOptions(circles: _geofenceEventLocations),
//            CircleLayerOptions(circles: _geofenceEventEdges),
//            CircleLayerOptions(circles: _currentPosition),
//          ],
//        ),
//        floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.add),
//          onPressed: () {},
//        ),
//      ),
//    );
//  }
//
//  @override
//  void dispose() {
//    print('[MapPage dispose()]');
//    removeServiceListener();
//    removeDateListener();
//    removeLocationListener();
//    super.dispose();
//  }
//}
