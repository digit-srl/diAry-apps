import 'dart:async';

import 'package:diary/application/location_notifier.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class AddPlacePage extends StatefulWidget {
  final LatLng location;

  const AddPlacePage({Key key, this.location}) : super(key: key);

  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  double radius = 20;

  TextEditingController placeEditingController = TextEditingController();

  TextEditingController descPlaceEditingController = TextEditingController();

  ThemeData themeData = ThemeData(primaryColor: accentColor);
  Circle place;
  BitmapDescriptor _currentPositionMarkerIcon;
  LatLng lastLocation;

  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Completer<GoogleMapController> _controller = Completer();
  double zoom = 19.0;
  Widget fab = Container();

  double _top;

  @override
  void initState() {
    super.initState();

    final locations = Provider.of<LocationNotifier>(context, listen: false)
        .getCurrentDayLocations;

    if (locations.isNotEmpty) {
      final coords = locations.last.coords;
      lastLocation = LatLng(coords.latitude, coords.longitude);
      addCircle(lastLocation);
      return;
    }
    getCurrentLocationAndUpdateMap();
  }

  addCircle(LatLng location) {
    circles.clear();

    Circle place = Circle(
      circleId: CircleId('place'),
      center: location,
      fillColor: Colors.orange.withOpacity(0.3),
      radius: radius,
      strokeWidth: 0,
    );
    circles.add(place);
  }

  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Aggiungi luogo',
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                key: _key,
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
//                    padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2.0,
                                    style: BorderStyle.solid,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Theme(
                                data: themeData,
                                child: TextField(
                                  controller: placeEditingController,
                                  decoration: InputDecoration(
                                      hintText: 'Nome luogo',
                                      labelText: 'Nome luogo'),
                                  onSubmitted: (text) {
                                    final size = _key.currentContext.size;
                                    _top = size.height - 30;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
//                    padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Container(),
                            ),
                            Flexible(
                              flex: 5,
                              child: Theme(
                                data: themeData,
                                child: TextField(
                                  controller: descPlaceEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Descrizione luogo',
                                    labelText: 'Descrizione',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
//                    padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Container(),
                            ),
                            Flexible(
                              flex: 5,
                              child: Slider(
                                min: 10.0,
                                max: 50.0,
                                divisions: 4,
                                label: '${radius.toInt()} m',
                                value: radius,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      this.radius = value;
                                      addCircle(lastLocation);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                  color: Colors.pink,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: lastLocation ?? LatLng(0.0, 0.0),
                          zoom: zoom,
                        ),
//                  onCameraMove: (cameraPosition) {
//                    setState(() {
//                      addCircle(cameraPosition.target);
//                    });
//                  },
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (location) {
                          setState(() {
                            addCircle(location);
                          });
                        },
                        markers: markers,
                        circles: circles,
                      ),
//                Positioned(
//                  top: -10,
//                  right: 0.0,
//                  child: FloatingActionButton(
//                    onPressed: () {},
//                  ),
//                ),
                      Positioned(
                        top: 30,
                        right: 10.0,
                        child: Container(
                          width: 35,
                          height: 35,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: accentColor, blurRadius: 3),
                            ],
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.gps_fixed),
                              iconSize: 17,
                              color: accentColor,
                              onPressed: getCurrentLocationAndUpdateMap,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: _top ?? 0.0,
            right: 10.0,
            child: _top != null
                ? FloatingActionButton(
                    onPressed: () {},
                    child: Icon(Icons.check),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_currentPositionMarkerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/my_position_pin.png')
          .then(_updateCurrentBitmap);
    }
  }

  void _updateCurrentBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _currentPositionMarkerIcon = bitmap;
    });
  }

  void getCurrentLocationAndUpdateMap() {
    bg.BackgroundGeolocation.getCurrentPosition().then((bg.Location location) {
      lastLocation =
          LatLng(location.coords.latitude, location.coords.longitude);
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('current'),
          icon: _currentPositionMarkerIcon,
          position: lastLocation,
        ),
      );

      addCircle(lastLocation);
      _goToLocation(lastLocation);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    });
  }

  Future<void> _goToLocation(LatLng loc) async {
    final GoogleMapController controller = await _controller.future;
    try {
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: zoom,
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
}