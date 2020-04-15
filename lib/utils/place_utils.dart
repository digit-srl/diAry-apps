import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/infrastructure/repositories/user_repository_impl.dart';
import 'package:diary/utils/alerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceUtils {
  // todo modified following new alert standard
  static showRemovePlaceAlert(BuildContext context, String identifier) async {
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
          },
    ).show();
  }
}
