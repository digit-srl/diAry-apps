import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/geofence_notifier.dart';
import 'package:flutter/material.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class PlaceLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<GeofenceState>(
      stateNotifier: context.watch<GeofenceNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        if (value.geofences.isEmpty) {
          return Container();
        }
        return Container(
//      height: 200,
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Color(0xFFEFF2F7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
//          mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Luoghi',
                style: titleCardStyle,
              ),
              Text(
                'Descrizione',
                style: secondaryStyle,
              ),
              SizedBox(
                height: 10,
              ),
              for (bg.Geofence geofence in value.geofences)
                PlaceRowLegend(
                  title: geofence.identifier,
                  pinColor: Colors.orange,
                  location:
                      'Lat: ${geofence.latitude} Long: ${geofence.longitude}',
                ),
//              Align(
//                alignment: Alignment.centerRight,
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: GenericButton(
//                    onPressed: () {},
//                    text: 'AGGIUNGI LUOGO',
//                  ),
//                ),
//              ),
            ],
          ),
        );
      },
    );
  }
}

class PlaceRowLegend extends StatelessWidget {
  final String title;
  final String location;
  final Color pinColor;

  const PlaceRowLegend({Key key, this.title, this.pinColor, this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
//            color: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                Icons.person_pin,
                color: pinColor,
                size: 50,
              ),
              Expanded(
                child: Container(
//                    height: 20,
//                    color: Colors.yellow,
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
//                          color: Colors.grey,
                        child: AutoSizeText(
                          title,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
//                          color: Colors.blue,
                        child: AutoSizeText(
                          location,
                          maxLines: 1,
                          style: secondaryStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: accentColor,
                onPressed: () {
                  Provider.of<GeofenceNotifier>(context, listen: false)
                      .removeGeofence(title);
                },
              ),
            ],
          ),
        ),
        Container(
          color: Colors.black,
          height: 1,
        ),
      ],
    );
  }
}
