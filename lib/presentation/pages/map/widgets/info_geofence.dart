import 'package:diary/utils/bottom_sheets.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/place_utils.dart';

import 'map_bottomsheets_utils.dart';

class InfoGeofenceWidget extends StatelessWidget {
  final ColoredGeofence coloredGeofence;

  InfoGeofenceWidget({this.coloredGeofence});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Row(
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    coloredGeofence.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
              ),
//            IconButton(
//              icon: Icon(Icons.edit),
//              onPressed: () async {
//                /* todo edit geofence action here
//                final place = Hive.box<Place>('places')
//                    .get(coloredGeofence.geofence.identifier);
//
//                await Navigator.of(context).push(
//                    MaterialPageRoute(
//                        builder: (BuildContext context) =>
//                            AddPlacePage(place: place)
//                    )
//                );
//                */
//              },
//              tooltip: "Modifica (coming soon!)",
//            ),
              IconButton(
                  icon: Icon(CustomIcons.trash_can_outline),
                  tooltip: 'Elimina',
                  onPressed: () async {
                    await PlaceUtils.showRemovePlaceAlert(
                        context, coloredGeofence.geofence.identifier);
                    // chiude il bottomsheet
                    Navigator.pop(context);
                  }),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          MapBottomsheetInfoBox(
            children: <Widget>[
              MapBottomsheetInfoLine(
                icon: Icon(Icons.gps_fixed),
                text:
                    'Lat: ${coloredGeofence.geofence.latitude?.toStringAsFixed(2)}, '
                    'Long: ${coloredGeofence.geofence.longitude?.toStringAsFixed(2)}',
              ),
              MapBottomsheetInfoLine(
                icon: Icon(Icons.settings_ethernet),
                text:
                    'Raggio: ${coloredGeofence.geofence.radius.toInt()} metri',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
