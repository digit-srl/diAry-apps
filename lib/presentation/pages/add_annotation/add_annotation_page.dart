import 'dart:async';

import 'package:diary/application/annotation_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/application/gps_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/presentation/widgets/detection_error_position_layer.dart';
import 'package:diary/presentation/widgets/gps_small_fab_button.dart';
import 'package:diary/presentation/widgets/manual_detection_position_layer.dart';
import 'package:diary/utils/app_theme.dart';
import 'package:diary/utils/bottom_sheets.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../main.dart';

class AddAnnotationPage extends StatefulWidget {
  final LatLng location;

  const AddAnnotationPage({Key key, this.location}) : super(key: key);

  @override
  _AddAnnotationPageState createState() => _AddAnnotationPageState();
}

class _AddAnnotationPageState extends State<AddAnnotationPage> {
  double radius = 20;
  TextEditingController annotationEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Circle _place;

  // BitmapDescriptor _currentPositionMarkerIcon;
  LatLng _lastLocation;
  bg.Location _foundLocation;

  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  double _zoom = 17.0;

  String _locationError;
  bool _canSave = false;

  DateTime selectedDate;
  String _darkMapStyle;
  String _normalMapStyle;

  @override
  void initState() {
    super.initState();
    selectedDate =
        Provider.of<DateNotifier>(context, listen: false).selectedDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocationAndUpdateMap();
    });

    rootBundle.loadString('assets/dark_map_style.json').then((string) {
      _darkMapStyle = string;
    });
    rootBundle.loadString('assets/normal_map_style.json').then((string) {
      _normalMapStyle = string;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // _createMarkerImageFromAsset(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            'Aggiungi annotazione',
            style: Theme.of(context).textTheme.title,
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help_outline),
              tooltip: "Cos'è questa schermata?",
              onPressed: () {
                _showHelper();
              },
            )
          ],
          elevation: 4,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(240.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: Column(
                children: <Widget>[
                  TextField(
                    cursorColor: Theme.of(context).iconTheme.color,
                    style: Theme.of(context).textTheme.body2,
                    controller: annotationEditingController,
                    expands: false,
                    maxLines: 7,
                    minLines: 7,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      hintStyle: Theme.of(context).textTheme.body1,
                      hintText:
                          "Che episodio desideri segnalare? Descrivilo in questo box.",
                    ),
                    onChanged: (text) {
                      setState(() {
                        _canSave =
                            (text.trim().length >= 3 && _foundLocation != null);
                      });
                    },
                    onSubmitted: (text) {},
                  ),
                ],
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _addAnnotationIfPossible,
        child: Icon(Icons.check),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GoogleMap(
            zoomGesturesEnabled: false,
            scrollGesturesEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target:
                  _lastLocation ?? LatLng(37.42796133580664, -122.085749655962),
              zoom: _zoom,
            ),
            onMapCreated: (controller) {
              controller.setMapStyle(AppTheme.isNightModeOn(context)
                  ? _darkMapStyle
                  : _normalMapStyle
              );
              _controller.complete(controller);
            },
            markers: _markers,
          ),
          ManualDetectionPositionLayer(),
          DetectionErrorPositionLayer(
              !context.watch<GpsState>().manualPositionDetection &&
                  _foundLocation == null),
          Positioned(
            top: 42,
            right: 25,
            child: GpsSmallFabButton(onPressed: _gpsClick),
          ),
        ],
      ),
    );
  }

  void _gpsClick() {
    // mostra una snackbar nel caso in cui il gps non sia disponibile
    if (!Provider.of<GpsState>(context, listen: false).gpsEnabled) {
      setState(() {
        _locationError = "No gps";
      });

      _showLocationErrorSnackbar();
    } else if (Provider.of<GpsState>(context, listen: false)
        .manualPositionDetection) {
      _showWaitPositionSnackbar();
    } else {
      _getCurrentLocationAndUpdateMap();
    }
  }

  void _getCurrentLocationAndUpdateMap() {
    // non provare neanche ad avviare la ricerca, nel caso in cui il gps non sia abilitato
    if (!Provider.of<GpsState>(context, listen: false).gpsEnabled) {
      setState(() {
        _locationError = "No gps";
      });
    } else {
      setState(() {
        _locationError = null;
      });

      context.read<GpsNotifier>().getCurrentLoc((bg.Location location) {
        _foundLocation = location;
        _lastLocation =
            LatLng(location.coords.latitude, location.coords.longitude);
        _goToLocation(_lastLocation);
        _addPin(_lastLocation);

        setState(() {
          _canSave = annotationEditingController.text.trim().length >= 3 &&
              _foundLocation != null;
        });
      }, (ex) {
        setState(() {
          _locationError = ex.toString();
        });
      });
    }
  }

  _addPin(LatLng location) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId('current'),
        icon:
            // forse è più corretto-chiaro mostrare il pin annotazione?
            annotationPositionMarkerIcon,
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

  void _addAnnotationIfPossible() {
    if (_canSave) {
      _addAnnotation();
    } else if (_locationError != null) {
      _showLocationErrorSnackbar();
    } else if (_foundLocation == null) {
      _showWaitPositionSnackbar();
    } else if (annotationEditingController.text.trim().length < 3) {
      _showShortTextSnackbar();
    }
  }

  void _addAnnotation() async {
    print('[AddAnnotationPage] Save annotation and close');
    // final box = Hive.box<Annotation>('annotations');
    final annotation = Annotation(
      id: _foundLocation.uuid,
      dateTime: DateTime.tryParse(_foundLocation.timestamp).toLocal(),
      title: annotationEditingController.text.trim(),
      latitude: _foundLocation.coords.latitude,
      longitude: _foundLocation.coords.longitude,
    );
    context.read<AnnotationNotifier>().addAnnotation(annotation);
    // final result = await box.add(annotation);
    print('[AddAnnotationPage] add annotation');
    Navigator.of(context).pop();
  }

  void _showLocationErrorSnackbar() {
    print('[AddAnnotationPage] Show location error Snackbar');
    _showSnackbar(
        'Errore nel rilevamento della tua posizione. Attiva i servizi GPS, se disattivati.',
        _gpsClick,
        'Riprova');
  }

  void _showShortTextSnackbar() {
    print('[AddAnnotationPage] Show short text Snackbar');
    _showSnackbar(
        "Il testo dell'annotazione deve avere una lunghezza minima di 3 caratteri.");
  }

  void _showWaitPositionSnackbar() {
    print('[AddAnnotationPage] Show short text Snackbar');
    _showSnackbar(
        "Rilevamento della posizione in corso. Attendine la terminazione.");
  }

  void _showSnackbar(String text, [Function action, String actionText]) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    final snackBar = SnackBar(
        content: Text(
          text,
        ),
        action: (action != null && actionText != null)
            ? SnackBarAction(
                label: actionText,
                onPressed: action,
              )
            : null);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _showHelper() async {
    print('[AddAnnotationPage] Show helper');

    BottomSheets.showInfoBottomSheet(context, StandardBottomSheetColumn(
      children: <Widget>[
        Text(
          "Cos'è questa schermata?",
          style: Theme.of(context).textTheme.headline,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Da qui è possibile aggiungere segnalare situazioni "
              "particolari degne di nota. L'annotazione verrà applicata "
              "alla tua posizione corrente, per cui è necessario autorizzare "
              "l'accesso alla localizzazione da parte dell'app per poterne "
              "aggiungere una.",
          style: Theme.of(context).textTheme.body1,
        ),
      ],
    ));
  }
}
