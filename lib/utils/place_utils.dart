import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/infrastructure/repositories/user_repository_impl.dart';
import 'package:diary/utils/alerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceUtils {
  // This is the alert to remove a place from the map. The boolean last
  // parameter handles elimination from map, that needs an additional pop to
  // close the bottomSheet.
  static showRemovePlaceAlert(BuildContext context, String identifier, [bool additionalPop]) async {
    return Alerts.showAlertWithPosNegActions(
        context,
        "Elimina luogo",
        "Sei sicuro di voler eliminare questo luogo?",
        "Sì, elimina",
        () {
          final homeIdentifier =
          Provider.of<UserRepositoryImpl>(context, listen: false)
              .getHomeGeofenceIdentifier();

            Provider.of<GeofenceNotifier>(context, listen: false)
              .removeGeofence(identifier);

            if (identifier == homeIdentifier) {
                Provider.of<UserRepositoryImpl>(context, listen: false)
                    .removeHomeGeofence();
            }

            if (!!additionalPop) {
              Navigator.pop(context);
            }
          },
    ).show();
  }
}
