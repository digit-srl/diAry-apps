import 'package:diary/utils/bottom_sheets.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/place_utils.dart';

class InfoGeofenceWidget extends StatelessWidget {
  final ColoredGeofence coloredGeofence;

  InfoGeofenceWidget({this.coloredGeofence});

  @override
  Widget build(BuildContext context) {
    return StandardBottomSheetColumn(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: coloredGeofence.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  //isHome ? CustomIcons.home_outline : CustomIcons.map_marker_outline,
                  CustomIcons.map_marker_outline,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: AutoSizeText(
                    "Luogo",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headline,
                  )),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                /* todo edit geofence action here
                final place = Hive.box<Place>('places')
                    .get(coloredGeofence.geofence.identifier);

                await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddPlacePage(place: place)
                    )
                );
                */
              },
              tooltip: "Modifica (coming soon!)",
            ),
            IconButton(
                icon: Icon(CustomIcons.trash_can_outline),
                tooltip: "Elimina",
                onPressed: () async {
                  await PlaceUtils.showRemovePlaceAlert(
                      context,
                      coloredGeofence.geofence.identifier
                  );
                  // chiude il bottomsheet
                  Navigator.pop(context);
                }),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
              child: Icon(
                Icons.message,
              ),
            ),
            Text(
              "Nome del luogo: " + coloredGeofence.name,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
              child: Icon(
                Icons.settings_ethernet,
              ),
            ),
            AutoSizeText(
              'Raggio: ${coloredGeofence.geofence.radius.toInt()} metri',
              maxLines: 1,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ],
    );
  }
}