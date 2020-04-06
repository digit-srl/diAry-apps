import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/annotation_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/application/gps_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

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

  ThemeData themeData = ThemeData(primaryColor: accentColor);
  Circle place;
//  BitmapDescriptor _currentPositionMarkerIcon;
  LatLng lastLocation;
  bg.Location newLocation;
  //final GlobalKey _key = GlobalKey();
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer();
  double zoom = 17.0;
  Widget fab = Container();
  bool isHomeEnabled;

  //Size get _size => _key?.currentContext?.size;
  String error;
  bool _canSave = false;

  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate =
        Provider.of<DateNotifier>(context, listen: false).selectedDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocationAndUpdateMap();
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
//    _createMarkerImageFromAsset(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
            'Aggiungi annotazione',
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(
            color: accentColor,
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
            preferredSize: const Size.fromHeight(260.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: Column(
                children: <Widget>[
                  Theme(
                    data: themeData,
                    child: TextField(
                      cursorColor: accentColor,
                      controller: annotationEditingController,
                      expands: false,
                      maxLines: 8,
                      minLines: 8,
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
                        hintText:
                            "Che episodio desideri segnalare? Descrivilo in questo box.",
                      ),
                      onChanged: (text) {
                        _canSave = (text.trim().length >= 3 && newLocation != null);
                        setState(() {});
                      },
                      onSubmitted: (text) {},
                    ),
                  ),
                ],
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _canSave ? () { _addAnnotation(); }
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
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            markers: markers,
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

  _addAnnotation() async {
//    final box = Hive.box<Annotation>('annotations');
    final annotation = Annotation(
      id: newLocation.uuid,
      dateTime: DateTime.tryParse(newLocation.timestamp).toLocal(),
      title: annotationEditingController.text.trim(),
      latitude: newLocation.coords.latitude,
      longitude: newLocation.coords.longitude,
    );
    context.read<AnnotationNotifier>().addAnnotation(annotation);
//    final result = await box.add(annotation);
    print('[AddAnnotationPage] add annotation');
    Navigator.of(context).pop();
  }

  void getCurrentLocationAndUpdateMap() {
    context.read<GpsNotifier>().getCurrentLoc((bg.Location location) {
      newLocation = location;
      lastLocation =
          LatLng(location.coords.latitude, location.coords.longitude);
      _goToLocation(lastLocation);
      addPin(lastLocation);

      setState(() {
        _canSave = annotationEditingController.text.trim().length >= 3 && newLocation != null;
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
        icon: currentPositionMarkerIcon,
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

  void _showHelper(BuildContext context) {
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
                  "Da qui è possibile aggiungere segnalare situazioni particolari degne di nota. L'annotazione verrà applicata alla tua posizione corrente, per cui è necessario autorizzare l'accesso alla localizzazione da parte dell'app per poterne aggiungere una.",
                  style: secondaryStyle,
                ),
              ],
            )
          );
        }
    );
  }
}
