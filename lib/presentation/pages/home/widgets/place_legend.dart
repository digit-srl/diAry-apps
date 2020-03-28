import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/utils/place_utils.dart';
import 'package:flutter/material.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

class PlaceLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<GeofenceState>(
        stateNotifier: context.watch<GeofenceNotifier>(),
        builder: (BuildContext context, value, Widget child) {
          if (value.geofences.isEmpty) {
            return Container();
          }
          return Card(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: baseCard,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText("I tuoi luoghi",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: titleCardStyle),

                  AutoSizeText("Vengono qua visualizzati tutti i luoghi che hai deciso di memorizzare.",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: secondaryStyle),

                  Container(
                    height: 8,
                  ),

                  for (ColoredGeofence coloredGeofence in value.geofences)
                    PlaceRowLegend(
                      title: coloredGeofence.geofence.identifier,
                      pinColor: coloredGeofence.color,
                      location: 'Lat: ${coloredGeofence.geofence.latitude.toStringAsFixed(2)} Long: ${coloredGeofence.geofence.longitude.toStringAsFixed(2)}',

                      lastLine: coloredGeofence == value.geofences.last,
                      onRemove: () {
                        PlaceUtils.removePlace(
                            context, coloredGeofence.geofence.identifier);
                      },
                    ),
                ],
              ),
            ),
          );
        });
  }

//  _onRemove(BuildContext context, String identifier) {
//    final homeIdentifier =
//        Provider.of<UserRepositoryImpl>(context, listen: false)
//            .getHomeGeofenceIdentifier();
//    showPlatformDialog(
//      context: context,
//      builder: (_) => BasicDialogAlert(
//        title: Text("Sicuro di voler cancellare questo luogo?"),
//        actions: <Widget>[
//          BasicDialogAction(
//            title: Text("Si"),
//            onPressed: () {
//              Provider.of<GeofenceNotifier>(context, listen: false)
//                  .removeGeofence(identifier);
//              if (identifier == homeIdentifier) {
//                Provider.of<UserRepositoryImpl>(context, listen: false)
//                    .removeHomeGeofence();
//              }
//              Navigator.pop(context);
//            },
//          ),
//          BasicDialogAction(
//            title: Text("No"),
//            onPressed: () {
//              Navigator.pop(context);
//            },
//          ),
//        ],
//      ),
//    );
//  }
}

class PlaceRowLegend extends StatelessWidget {
  final String title;
  final String location;
  final Color pinColor;
  final Function onRemove;
  final bool lastLine;

  const PlaceRowLegend(
      {Key key,
      this.title,
      this.pinColor,
      this.location,
      this.onRemove,
      this.lastLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
//            color: Colors.green,
          padding: const EdgeInsets.fromLTRB(0,16, 0, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 48,
                height: 40,
                decoration: BoxDecoration(
                  color: pinColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.place,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
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
                onPressed: onRemove,
              ),
            ],
          ),
        ),
        if (!lastLine)
          Divider(
            height: 1,
          )
      ],
    );
  }
}
