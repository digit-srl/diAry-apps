import 'package:diary/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GenericUtils {
  static showError(BuildContext context, {String error}) {
    Alert(
      context: context,
      title: 'Si è verificato un errore!',
      desc: error,
      buttons: [
        DialogButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  static ask(BuildContext context, String title, Function confirm,
      Function exit) async {
    return await Alert(
      context: context,
      title: title,
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            'ANNULLA',
          ),
          onPressed: () {
            exit();
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            'SI',
            style: whiteText,
          ),
          onPressed: () {
            confirm();
            Navigator.pop(context, true);
          },
        ),
      ],
    ).show();
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
