import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:diary/infrastructure/user_repository.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/colors.dart';

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
  Color currentColor = Colors.orange;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Completer<GoogleMapController> _controller = Completer();
  double zoom = 19.0;
  Widget fab = Container();
  bool isHomeEnabled;
  String error;
  bool _canSave = false;

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
        iconTheme: IconThemeData(color: accentColor),
        title: Text(
          'Aggiungi luogo',
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(260.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _selectColor,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 16, 20),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: currentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Theme(
                        data: themeData,
                        child: TextField(
                          cursorColor: accentColor,
                          controller: placeEditingController,
                          expands: false,
                          maxLines: 1,
                          maxLength: 20,
                          style: TextStyle(fontFamily: "Nunito"),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.black12,
                            hintText: "Inserisci qui il nome del luogo",
                          ),
                          onChanged: (text) {
                            _canSave = (text.trim().length >= 3 &&
                                newLocation != null);
                            setState(() {});
                          },
                          onSubmitted: (text) {
                            if (_canSave) _addGeofence();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Abitazione principale",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          AutoSizeText(
                            "Puoi impostare un solo luogo.",
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
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
                Container(height: 16),
                Text(
                  "Raggio",
                  textAlign: TextAlign.left,
                ),
                Slider(
                  min: 10.0,
                  max: 50.0,
                  divisions: 4,
                  label: '${radius.toInt()} metri',
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _canSave
            ? () {
                _addGeofence();
              }
            : null,
        backgroundColor: _canSave ? accentColor : Colors.grey,
        child: Icon(Icons.check),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
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
          if (newLocation == null)
            Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  Container(
                    height: 16,
                  ),
                  Text(
                    'Acquisendo la tua posizione corrente...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          Positioned(
            child: Container(
              height: 40.0,
              width: 40.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.gps_fixed),
                    iconSize: 16,
                    color: accentColor,
                    onPressed: getCurrentLocationAndUpdateMap,
                  ),
                ),
              ),
            ),
            top: 42,
            right: 25,
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
    final uuid = Uuid().v1();
    final name = placeEditingController.text.trim().toUpperCase();
    final int color = currentColor.value;
    final geofence = bg.Geofence(
      identifier: uuid,
      radius: radius,
      latitude: lastLocation.latitude,
      longitude: lastLocation.longitude,
      notifyOnEntry: true,
      notifyOnExit: true,
      extras: {
        'name': name,
        'color': color,
        'isHome': _isHome,
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
          final newPlace = Place(uuid, name, color, _isHome,
              lastLocation.latitude, lastLocation.latitude, geofence.radius);
          Provider.of<GeofenceNotifier>(context, listen: false)
              .addGeofence(geofence, currentColor, name);
          Hive.box<Place>('places').put(geofence.identifier, newPlace);
          if (_isHome) {
            Provider.of<UserRepositoryImpl>(context, listen: false)
                .setHomeGeofenceIdentifier(uuid);
          }
          Navigator.of(context).pop();
        } else {
          GenericUtils.showError(context);
        }
      },
    ).catchError(
      (error) {
        print('[addGeofence] ERROR: $error');
        GenericUtils.showError(context, error: error.toString());
      },
    );
  }

  Future<void> _goToLocation(LatLng loc) async {
    if (!mounted) return;
    final GoogleMapController controller = await _controller.future;
    try {
      controller?.moveCamera(
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
          _canSave = placeEditingController.text.trim().length >= 3 &&
              newLocation != null;
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
