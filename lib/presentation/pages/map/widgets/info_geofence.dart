import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/bottom_sheets.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/place_utils.dart';

import 'map_bottomsheets_utils.dart';

class InfoGeofenceBody extends StatelessWidget {
  final ColoredGeofence geofence;

  const InfoGeofenceBody(this.geofence, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MapBottomsheetInfoBox(children: <Widget>[
      MapBottomsheetInfoLine(
        icon: Icon(Icons.gps_fixed),
        text: 'Lat: ${geofence.geofence.latitude?.toStringAsFixed(2)}, '
            'Long: ${geofence.geofence.longitude?.toStringAsFixed(2)}',
      ),
      MapBottomsheetInfoLine(
        icon: Icon(Icons.settings_ethernet),
        text: 'Raggio: ${geofence.geofence.radius.toInt()} metri',
      ),
    ]);
  }
}

class InfoGeofenceHeader extends StatelessWidget {
  final ColoredGeofence geofence;

  const InfoGeofenceHeader(this.geofence, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapBottomsheetHeader(
      child: Row(children: <Widget>[
        MapBottomsheetHeaderIcon(CustomIcons.pin_outline,
            color: geofence.color),
        SizedBox(width: 16),
        Expanded(
          child: AutoSizeText(
            geofence.name,
            maxLines: 3,
            style: Theme.of(context).textTheme.headline,
          ),
        ),
      ]),
    );
  }
}

class InfoGeofenceFooter extends StatelessWidget {
  final ColoredGeofence geofence;

  const InfoGeofenceFooter(this.geofence, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapBottomsheetFooter(buttons: <GenericButton>[
      GenericButton(
        text: 'Elimina',
        onPressed: () async {
          await PlaceUtils.showRemovePlaceAlert(
              context, geofence.geofence.identifier);
          // chiude il bottomsheet
          Navigator.pop(context);
        },
      ),
    ]);
  }
}
