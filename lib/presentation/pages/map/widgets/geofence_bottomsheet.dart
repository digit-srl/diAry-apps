import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/domain/entities/colored_geofence.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/place_utils.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

void showGeofenceBottomSheet(
    ColoredGeofence coloredGeofence, BuildContext context) async {

  await showSlidingBottomSheet(
    context,
    useRootNavigator: true,
    builder: (context) {
      return SlidingSheetDialog(
        backdropColor: Colors.black.withOpacity(0.0),
        elevation: 8,
        cornerRadius: 16,
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(16.0),
        //minHeight: 400,
        duration: Duration(milliseconds: 300),
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (ctx, sheetState) {
          return Container(
            child: Material(
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
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
                        onPressed: () {},
                        tooltip: "Modifica (coming soon!)",
                      ),
                      IconButton(
                          icon: Icon(CustomIcons.trash_can_outline),
                          tooltip: "Elimina",
                          onPressed: () async {
                            final deleted = await PlaceUtils.removePlace(
                                context, coloredGeofence.geofence.identifier);
                            if (deleted) {
                              Navigator.of(context).pop();
                            }
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
              ),
            ),
          );
        },
      );
    },
  );
}
