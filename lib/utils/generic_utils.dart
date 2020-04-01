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

  static List<int> minutesToHourAndMinutes(int minutes) {
    final x = minutes / 60.0;
    int hours = x.toInt();
    String minString = x.toStringAsFixed(2).split('.')[1];
    int min = (int.parse(minString) / 100 * 60).truncate();
    return [hours, min];
  }

  static Duration minutesToDuration(int minutes) {
    final list = minutesToHourAndMinutes(minutes);
    return Duration(hours: list[0], minutes: list[1]);
  }

  static String minutesToString(int minutes) {
    if (minutes <= 60) return '$minutes min';
    final list = GenericUtils.minutesToHourAndMinutes(minutes);
    final hour = list[0];
    final min = list[1];
    if (min == 0) return '$hour h';
    return '$hour h : $min m';
  }
}
