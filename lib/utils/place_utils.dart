import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/infrastructure/repositories/user_repository_impl.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PlaceUtils {
  static removePlace(BuildContext context, String identifier) async {
    final homeIdentifier =
        Provider.of<UserRepositoryImpl>(context, listen: false)
            .getHomeGeofenceIdentifier();
    return await Alert(
      context: context,
      title: 'Sicuro di voler eliminare questo luogo?',
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            'ANNULLA',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            'SI',
            style: whiteText,
          ),
          onPressed: () {
            Provider.of<GeofenceNotifier>(context, listen: false)
                .removeGeofence(identifier);
            if (identifier == homeIdentifier) {
              Provider.of<UserRepositoryImpl>(context, listen: false)
                  .removeHomeGeofence();
            }
            Navigator.pop(context, true);
          },
        ),
      ],
    ).show();
  }
}
