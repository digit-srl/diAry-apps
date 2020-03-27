import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/infrastructure/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class PlacesCard extends StatelessWidget {
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
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: baseCard,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText("I tuoi luoghi",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: titleCardStyle),
                  SizedBox(height: 8),
                  for (bg.Geofence geofence in value.geofences)
                    PlaceRowLegend(
                      title: geofence.identifier,
                      pinColor: Colors.orange,
                      location:
                          'Lat: ${geofence.latitude.toStringAsFixed(2)} Long: ${geofence.longitude.toStringAsFixed(2)}',
                      onRemove: () {
                        _onRemove(context, geofence.identifier);
                      },
                    ),
                ],
              ),
            ),
          );
        });
  }

  _onRemove(BuildContext context, String identifier) {
    final homeIdentifier =
        Provider.of<UserRepositoryImpl>(context, listen: false)
            .getHomeGeofenceIdentifier();
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Sicuro di voler cancellare questo luogo?"),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Annulla"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Si"),
            onPressed: () {
              Provider.of<GeofenceNotifier>(context, listen: false)
                  .removeGeofence(identifier);
              if (identifier == homeIdentifier) {
                Provider.of<UserRepositoryImpl>(context, listen: false)
                    .removeHomeGeofence();
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class PlaceRowLegend extends StatelessWidget {
  final String title;
  final String location;
  final Color pinColor;
  final Function onRemove;

  const PlaceRowLegend(
      {Key key, this.title, this.pinColor, this.location, this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
//            color: Colors.green,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                Icons.place,
                color: pinColor,
                size: 28,
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
      ],
    );
  }
}
