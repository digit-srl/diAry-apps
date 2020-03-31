import 'dart:async';

import 'package:diary/application/day_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class AddAnnotationPage extends StatefulWidget {
  final LatLng location;

  const AddAnnotationPage({Key key, this.location}) : super(key: key);

  @override
  _AddAnnotationPageState createState() => _AddAnnotationPageState();
}

class _AddAnnotationPageState extends State<AddAnnotationPage> {
  double radius = 20;
  TextEditingController annotationEditingController = TextEditingController();

  ThemeData themeData = ThemeData(primaryColor: accentColor);
  Circle place;
  BitmapDescriptor _currentPositionMarkerIcon;
  LatLng lastLocation;
  bg.Location newLocation;
  final GlobalKey _key = GlobalKey();
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer();
  double zoom = 19.0;
  Widget fab = Container();
  bool isHomeEnabled;

  Size get _size => _key?.currentContext?.size;
  String error;
  double _top;

  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate =
        Provider.of<DateNotifier>(context, listen: false).selectedDate;
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
          'Aggiungi segnalazione',
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
                            controller: annotationEditingController,
//                            expands: true,
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                                hintText: 'Nome segnalazione',
                                labelText: 'Nome segnalazione',
                                labelStyle: TextStyle(color: secondaryText)),
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
                      Flexible(
                        child: Container(),
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
                      onMapCreated: (controller) {
                        _controller.complete(controller);
                      },
                      markers: markers,
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
                    error != null
                        ? Positioned(
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
                        : Container(),
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
                    onPressed: _addAnnotation,
                    child: Icon(Icons.check),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  _addAnnotation() async {
    final box = Hive.box<Annotation>('annotations');
    final annotation = Annotation(
      id: newLocation.uuid,
      dateTime: DateTime.tryParse(newLocation.timestamp).toLocal(),
      title: annotationEditingController.text.trim(),
      latitude: newLocation.coords.latitude,
      longitude: newLocation.coords.longitude,
    );
    Provider.of<DayNotifier>(context, listen: false).addAnnotation(annotation);
    final result = await box.add(annotation);
    print('[AddAnnotationPage] add annotation $result');
    Navigator.of(context).pop();
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
    LocationUtils.getCurrentLocationAndUpdateMap((bg.Location location) {
      newLocation = location;
      lastLocation =
          LatLng(location.coords.latitude, location.coords.longitude);
      _goToLocation(lastLocation);
      addPin(lastLocation);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (annotationEditingController.text.trim().length >= 3 &&
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
}
