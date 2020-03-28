import 'dart:async';

import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/infrastructure/user_repository.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:rflutter_alert/rflutter_alert.dart';

class AddPlacePage extends StatefulWidget {
  final LatLng location;

  const AddPlacePage({Key key, this.location}) : super(key: key);

  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  double radius = 20;
  bool _isHome = false;
  TextEditingController placeEditingController = TextEditingController();

  ThemeData themeData = ThemeData(primaryColor: accentColor);
  Circle place;
  BitmapDescriptor _currentPositionMarkerIcon;
  LatLng lastLocation;
  bg.Location newLocation;

  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Completer<GoogleMapController> _controller = Completer();
  double zoom = 19.0;
  Widget fab = Container();
  bool isHomeEnabled;
  final GlobalKey _key = GlobalKey();

  Size get _size => _key?.currentContext?.size;
  String error;
  double _top;

  @override
  void initState() {
    super.initState();
    isHomeEnabled = !Provider.of<UserRepositoryImpl>(context, listen: false)
        .isThereHomeGeofence();
    final locations = Provider.of<LocationNotifier>(context, listen: false)
        .getCurrentDayLocations;

    if (locations.isNotEmpty) {
      final coords = locations.last.coords;
      lastLocation = LatLng(coords.latitude, coords.longitude);
    }
    getCurrentLocationAndUpdateMap();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

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
                      Row(
//                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: GestureDetector(
                                onTap: _selectColor,
                                child: Container(
                                  margin: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: currentColor,
//                                    border: Border.all(
//                                      color: Colors.grey,
//                                      width: 2.0,
//                                      style: BorderStyle.solid,
//                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Theme(
                              data: themeData,
                              child: TextField(
                                controller: placeEditingController,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  hintText: 'Nome luogo',
                                  labelText: 'Nome luogo',
                                  labelStyle: TextStyle(color: secondaryText),
                                ),
                                onChanged: (text) {
                                  if (text.trim().length >= 3 &&
                                      newLocation != null) {
                                    _top = _size.height - 30;
                                  } else {
                                    _top = null;
                                  }
                                  setState(() {});
                                },
                                onSubmitted: (text) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
//                    padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(),
                            ),
                            Flexible(
                              flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Abitazione principale',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Switch(
                                    value: _isHome,
                                    onChanged: isHomeEnabled
                                        ? (bool value) {
                                            setState(() {
                                              this._isHome = value;
                                            });
                                          }
                                        : null,
                                  ),
                                ],
                              ),
//                              child: Theme(
//                                data: themeData,
//                                child: TextField(
//                                  controller: descPlaceEditingController,
//                                  decoration: InputDecoration(
//                                    hintText: 'Descrizione luogo',
//                                    labelText: 'Descrizione',
//                                  ),
//                                ),
//                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
//                    padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 5,
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
                          lastLocation = location;
                          addCircle(location);
                        });
                      },
                      markers: markers,
                      circles: circles,
                    ),
                    newLocation == null
                        ? Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                'Acquisizione Posizione...',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          )
                        : Container(),
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
            ],
          ),
          Positioned(
            top: _top ?? 0.0,
            right: 10.0,
            child: _top != null
                ? FloatingActionButton(
                    onPressed: _addGeofence,
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

//  void getCurrentLocationAndUpdateMap() {
//    bg.BackgroundGeolocation.getCurrentPosition(
//      persist: true,
//      maximumAge: 5000,
//      timeout: 10,
//      samples: 5,
//      desiredAccuracy: 5,
//    ).then((bg.Location location) {
//
//    });
//  }

  void _addGeofence() {
    final geofence = bg.Geofence(
      identifier: placeEditingController.text.trim().toUpperCase(),
      radius: radius,
      latitude: lastLocation.latitude,
      longitude: lastLocation.longitude,
      notifyOnEntry: true,
      notifyOnExit: true,
      extras: {
        'radius': radius,
        'center': {
          'latitude': lastLocation.latitude,
          'longitude': lastLocation.longitude
        }
      },
    );

    //TODO spostare in GeofenceNotifier
    bg.BackgroundGeolocation.addGeofence(geofence).then(
      (bool success) {
        if (success) {
          Provider.of<GeofenceNotifier>(context, listen: false)
              .addGeofence(geofence, currentColor);
          Hive.box<int>('geofences_color')
              .put(geofence.identifier, currentColor.value);
          if (_isHome) {
            Provider.of<UserRepositoryImpl>(context, listen: false)
                .setHomeGeofenceIdentifier(geofence.identifier);
          }
          Navigator.of(context).pop();
        }
      },
    ).catchError(
      (error) {
        print('[addGeofence] ERROR: $error');
      },
    );
  }

  Future<void> _goToLocation(LatLng loc) async {
    if (!mounted) return;
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

  Color currentColor = Colors.orange;

  void _selectColor() async {
    Color tmpColor = currentColor;
    await Alert(
      style: AlertStyle(
        animationType: AnimationType.grow,
      ),
      context: context,
      title: 'Scegli il colore',
      content: BlockPicker(
        onColorChanged: (Color value) {
          tmpColor = value;
        },
        pickerColor: tmpColor,
        layoutBuilder:
            (BuildContext context, List<Color> colors, PickerItem child) {
          Orientation orientation = MediaQuery.of(context).orientation;
          return Container(
            width: orientation == Orientation.portrait ? 300.0 : 300.0,
            height: orientation == Orientation.portrait ? 300.0 : 200.0,
            child: GridView.count(
              crossAxisCount: orientation == Orientation.portrait ? 5 : 6,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              children: colors.map((Color color) => child(color)).toList(),
            ),
          );
        },
      ),
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text('Annulla'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        DialogButton(
          child: Text(
            'Conferma',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              this.currentColor = tmpColor;
              addCircle(lastLocation);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  void getCurrentLocationAndUpdateMap() {
    LocationUtils.getCurrentLocationAndUpdateMap((bg.Location location) {
      newLocation = location;
      lastLocation =
          LatLng(location.coords.latitude, location.coords.longitude);
      _goToLocation(lastLocation);
      addPin(lastLocation);
      addCircle(lastLocation);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (placeEditingController.text.trim().length >= 3 &&
              newLocation != null) {
            _top = _size.height - 30;
          } else {
            _top = null;
          }
        });
      });
    }, (ex) {
      error = ex.toString();
    });
  }

  addCircle(LatLng location) {
    circles.clear();

    Circle place = Circle(
      circleId: CircleId('place'),
      center: location,
      fillColor: currentColor.withOpacity(0.3),
      radius: radius,
      strokeWidth: 0,
    );
    circles.add(place);
  }

  addPin(LatLng location) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId('current'),
        icon: _currentPositionMarkerIcon,
        position: location,
      ),
    );
  }
}
