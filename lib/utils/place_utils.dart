import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/infrastructure/repositories/user_repository_impl.dart';
import 'package:diary/utils/alerts.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PlaceUtils {
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
        }
    );

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
  }
}
