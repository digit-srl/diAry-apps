import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/application/gps_notifier.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:diary/infrastructure/user_repository.dart';
import 'package:diary/presentation/widgets/gps_small_fab_button.dart';
import 'package:diary/presentation/widgets/manual_detection_position_layer.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

import '../../../main.dart';

import '../../../utils/colors.dart';

class AddPlacePage extends StatefulWidget {
  final LatLng location;
  const AddPlacePage({Key key, this.location}) : super(key: key);

  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double _radius = 20;
  bool _isHome = false;
  TextEditingController _placeEditingController = TextEditingController();
  Circle _place;
//  BitmapDescriptor _currentPositionMarkerIcon;
  LatLng _lastLocation;
//  bg.Location newLocation;
  Color _currentColor = Colors.orange;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  Completer<GoogleMapController> _controller = Completer();
  double _zoom = 17.0;
  bool _isHomeEnabled;
  String _locationError;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    _isHomeEnabled = !Provider.of<UserRepositoryImpl>(context, listen: false)
        .isThereHomeGeofence();
    final locations = Provider.of<LocationNotifier>(context, listen: false)
        .getCurrentDayLocations;

    if (locations.isNotEmpty) {
      final coords = locations.last.coords;
      _lastLocation = LatLng(coords.latitude, coords.longitude);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _goToLocation(_lastLocation);
        // forse più corretto non mostrarlo? In questo modo sarebbe più facile
        // spostare il cerchio, rendendo cliccabile anche l'area del pin
        //_addPin(lastLocation);
        _addCircle(_lastLocation);
        setState(() {
          _canSave = _placeEditingController.text.trim().length >= 3;
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getCurrentLocationAndUpdateMap();
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
//    _createMarkerImageFromAsset(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: accentColor),
        title: Text(
          'Aggiungi luogo',
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help_outline),
            tooltip: "Cos'è questa schermata?",
            onPressed: () {
              _showHelper(context);
            },
          )
        ],
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(240.0),
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
                          color: _currentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Theme(
                        data: ThemeData(primaryColor: accentColor),
                        child: TextField(
                          cursorColor: accentColor,
                          controller: _placeEditingController,
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
                            fillColor: baseCard,
                            hintText: "Inserisci qui il nome del luogo",
                          ),
                          onChanged: (text) {
                            setState(() {
                              _canSave = (text.trim().length >= 3 && _lastLocation != null);
                            });
                          },
                          onSubmitted: (text) {
                            if (_canSave) _addGeofence();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox( height: 4 ),
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

                        ],
                      ),
                    ),
                    Switch(
                      value: _isHome,
                      onChanged: _isHomeEnabled
                          ? (bool value) {
                              setState(() {
                                this._isHome = value;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),

                Text(
                  "Raggio",
                  textAlign: TextAlign.left,
                  style: secondaryStyle,
                ),
                Slider(
                  min: 10.0,
                  max: 50.0,
                  divisions: 4,
                  label: '${_radius.toInt()} metri',
                  value: _radius,
                  onChanged: (value) {
                    setState(() {
                        this._radius = value;
                        _addCircle(_lastLocation);
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
        onPressed: _addPlaceIfPossible,
        child: Icon(Icons.check),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _lastLocation ?? LatLng(37.42796133580664, -122.085749655962),
              zoom: _zoom,
            ),
           // onCameraMove: (cameraPosition) {
           //   setState(() {
           //   addCircle(cameraPosition.target);
           // });
           //},
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            onTap: (location) {
              setState(() {
                _lastLocation = location;
                _addCircle(location);
              });
            },
            markers: _markers,
            circles: _circles,
          ),
          ManualDetectionPositionLayer(),
          Positioned(
            top: 42,
            right: 25,
            child: GpsSmallFabButton(
              onPressed: _getCurrentLocationAndUpdateMap,
            ),
          ),
        ],
      ),
    );
  }

//  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
//    if (_currentPositionMarkerIcon == null) {
//      final ImageConfiguration imageConfiguration =
//          createLocalImageConfiguration(context);
//      BitmapDescriptor.fromAssetImage(
//              imageConfiguration, 'assets/my_position_pin.png')
//          .then(_updateCurrentBitmap);
//    }
//  }
//
//  void _updateCurrentBitmap(BitmapDescriptor bitmap) {
//    setState(() {
//      _currentPositionMarkerIcon = bitmap;
//    });
//  }

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
    final name = _placeEditingController.text.trim().toUpperCase();
    final int color = _currentColor.value;
    final geofence = bg.Geofence(
      identifier: uuid,
      radius: _radius,
      latitude: _lastLocation.latitude,
      longitude: _lastLocation.longitude,
      notifyOnEntry: true,
      notifyOnExit: true,
      extras: {
        'name': name,
        'color': color,
        'isHome': _isHome,
        'radius': _radius,
        'center': {
          'latitude': _lastLocation.latitude,
          'longitude': _lastLocation.longitude
        }
      },
    );

    //TODO spostare in GeofenceNotifier
    bg.BackgroundGeolocation.addGeofence(geofence).then(
      (bool success) {
        if (success) {
          final newPlace = Place(uuid, name, color, _isHome,
              _lastLocation.latitude, _lastLocation.latitude, geofence.radius);
          Provider.of<GeofenceNotifier>(context, listen: false)
              .addGeofence(geofence, _currentColor, name);
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
            zoom: _zoom,
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
    Color tmpColor = _currentColor;
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
              this._currentColor = tmpColor;
              _addCircle(_lastLocation);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  void _getCurrentLocationAndUpdateMap() {
    context.read<GpsNotifier>().getCurrentLoc((bg.Location location) {
      _lastLocation =
          LatLng(location.coords.latitude, location.coords.longitude);
      _goToLocation(_lastLocation);
      // forse più corretto non mostrarlo? In questo modo sarebbe più facile
      // spostare il cerchio, rendendo cliccabile anche l'area del pin
      // _addPin(lastLocation);
      _addCircle(_lastLocation);
      setState(() {
        _canSave = _placeEditingController.text.trim().length >= 3;
      });
    }, (ex) {
      _locationError = ex.toString();
    });
  }

  _addCircle(LatLng location) {
    _circles.clear();
    Circle place = Circle(
      circleId: CircleId('place'),
      center: location,
      fillColor: _currentColor.withOpacity(0.3),
      radius: _radius,
      strokeWidth: 0,
    );
    _circles.add(place);
  }

  _addPin(LatLng location) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId('current'),
        icon: currentPositionMarkerIcon,
        position: location,
      ),
    );
  }

  void _addPlaceIfPossible() {
    if (_canSave) {
      _addGeofence();
    } else if (_placeEditingController.text.trim().length < 3) {
      _showShortTextSnackbar();
    }
  }

  void _showShortTextSnackbar() {
    print('[AddPlacePage] Show short text Snackbar');
    _showSnackbar("Il nome del luogo deve avere una lunghezza minima di 3 caratteri.");
  }

  void _showSnackbar(String text, [Function action, String actionText]) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    final snackBar = SnackBar(
        content: Text(
          text,
          style: TextStyle(fontFamily: "Nunito"),
        ),

        action: (action != null && actionText != null)
            ? SnackBarAction(
          textColor: Colors.white,
          label: actionText,
          onPressed: action,
        )
            : null
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _showHelper(BuildContext context) {
    print('[AddPlacePage] Show helper');
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Cos'è questa schermata?",
                    style: titleCardStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Da qui è possibile aggiungere o modificare un luogo, così "
                    "da rendere più preciso l'operato dell'app. Posiziona il "
                    "luogo premendo in un qualunque punto nella mappa. Puoi "
                    "inoltre sceglierne il nome, il colore con quale "
                    "visualizzarlo nella mappa, il raggio, e specificare se è "
                    "la tua abitazione principale. Passando più tempo nella tua "
                    "abitazione principale, otterrai un maggior numero di WOM.",
                    style: secondaryStyle,
                  ),
                ],
              )
          );
        }
    );
  }
}
