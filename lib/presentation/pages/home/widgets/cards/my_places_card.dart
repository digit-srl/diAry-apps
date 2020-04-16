import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/place_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

/*
 * The card shows all the currently ENABLED places, and lets to the user the
 * possibility to modify or delete them.
 */
class MyPlacesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<GeofenceState>(
        stateNotifier: context.watch<GeofenceNotifier>(),
        builder: (BuildContext context, value, Widget child) {
          Set<Place> places;
          places = Hive.box<Place>('places')
              .values
              .where((place) => place.enabled == true)
              .toSet();

          if (places.isEmpty) {
            return Container();
          }

          return Card(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Theme.of(context).cardTheme.color,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText("I tuoi luoghi",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline),
                  Text(
                      'Lista di tutti i luoghi attualmente annotati sulla mappa.',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.body1),
                  Container(
                    height: 8,
                  ),
                  for (Place place in places)
                    PlaceRowLegend(
                      title: place.name,
                      isHome: place.isHome,
                      pinColor: Color(place.color),
                      geoRadius: "Raggio: " +
                          place.radius.toInt().toString() +
                          " metri",
                      lastLine: place == places.last,
                      location: 'Lat: ${place.latitude.toStringAsFixed(2)} '
                          'Long: ${place.longitude.toStringAsFixed(2)}',
                      onRemove: () {
                        PlaceUtils.showRemovePlaceAlert(
                            context, place.identifier);
                      },
                    ),
                ],
              ),
            ),
          );
        });
  }
}

class PlaceRowLegend extends StatelessWidget {
  final String title;
  final String location;
  final String geoRadius;
  final Color pinColor;
  final Function onRemove;
  final bool lastLine;
  final bool isHome;

  const PlaceRowLegend(
      {Key key,
      this.title,
      this.pinColor,
      this.location,
      this.geoRadius,
      this.onRemove,
      this.lastLine,
      this.isHome = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          highlightColor:
              Theme.of(context).textTheme.body1.color.withOpacity(0.3),
          splashColor: Theme.of(context).textTheme.body1.color.withOpacity(0.3),
          onTap: () {
            print("hey");
            // todo edit place
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                      isHome
                          ? CustomIcons.home_outline
                          : CustomIcons.map_marker_outline,
                      color: Theme.of(context).primaryColor,
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
                          child: AutoSizeText(
                            title,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                        Container(
                          child: AutoSizeText(
                            geoRadius, // location,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(CustomIcons.trash_can_outline),
                  onPressed: onRemove,
                  tooltip: "Elimina luogo",
                ),
              ],
            ),
          ),
        ),
        if (!lastLine) Divider(height: 1)
      ],
    );
  }
}
