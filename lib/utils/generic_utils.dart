import 'package:diary/domain/entities/motion_activity.dart';
import 'package:diary/domain/entities/slice.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'constants.dart';

class GenericUtils {
  static AlertStyle customStyle(BuildContext context) {
    AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      descStyle: Theme.of(context).textTheme.body1,
      backgroundColor: Theme.of(context).primaryColor,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
      titleStyle: Theme.of(context).textTheme.headline,
    );
  }



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

  static int getOffMinutes(List<Slice> slices) {
    int offMinutes = 0;
    final offSlices = slices?.where((p) => p.activity == MotionActivity.Off);
    if (offSlices.isNotEmpty) {
      offMinutes = offSlices
          ?.map((slice) => slice.minutes)
          ?.reduce((curr, next) => curr + next);
    }
    return offMinutes;
  }

  static int getUnknownMinutes(List<Slice> slices) {
    int unknownMinutes = 0;
    final unknownSlices =
        slices?.where((p) => p.activity == MotionActivity.Unknown);
    if (unknownSlices.isNotEmpty) {
      unknownMinutes = unknownSlices
          ?.map((slice) => slice.minutes)
          ?.reduce((curr, next) => curr + next);
    }
    return unknownMinutes;
  }

  static int getHomeMinutes(List<Slice> slices, String homeIdentifier) {
    int homeMinutes = 0;
    final homeSlices = slices.where((p) => p.places.contains(homeIdentifier));
    if (homeSlices.isNotEmpty) {
      homeMinutes = homeSlices
          .map((slice) => slice.minutes)
          .reduce((curr, next) => curr + next);
    }
    return homeMinutes;
  }

  static int getMinutesAtOtherKnownLocations(
      List<Slice> slices, String homeIdentifier) {
    int minutesAtOtherKnownLocations = 0;
    final otherKnownLocationsSlices =
        slices.where((p) => p.places.isNotEmpty).toList();
    otherKnownLocationsSlices.removeWhere(
        (p) => p.places.length == 1 && p.places.contains(homeIdentifier));
    if (otherKnownLocationsSlices.isNotEmpty) {
      minutesAtOtherKnownLocations = otherKnownLocationsSlices
          .map((slice) => slice.minutes)
          .reduce((curr, next) => curr + next);
    }
    return minutesAtOtherKnownLocations;
  }

  static int getTotalMinutesTracked(List<Slice> slices) {
    final int offMinutes = GenericUtils.getOffMinutes(slices);
    final int unknownMinutes = GenericUtils.getUnknownMinutes(slices);
    final int totalMinutesTracked =
        maxDailyMinutes - offMinutes - unknownMinutes;
    if (totalMinutesTracked < 0) {
      throw Exception(
          '[GeneriUtils] totalMinutesTracked cannont to be less that zero');
    }
    return totalMinutesTracked;
  }

  static int getMinutesElsewhere(List<Slice> slices) {
    int minutesElsewhere = 0;
    final slicesElseWhere = slices.where((p) =>
        p.places.isEmpty &&
        p.activity != MotionActivity.Off &&
        p.activity != MotionActivity.Unknown);
    if (slicesElseWhere.isNotEmpty) {
      minutesElsewhere = slicesElseWhere
          .map((slice) => slice.minutes)
          .reduce((curr, next) => curr + next);
    }
    if (minutesElsewhere < 0) {
      throw Exception(
          '[GeneriUtils] totalMinutesTracked cannont to be less that zero');
    }
    return minutesElsewhere;
  }

  static int getWomCountForThisDay(List<Slice> places) {
    try {
      int offMinutes = 0;
      int unknownMinutes = 0;

      final offSlices = places?.where((p) => p.activity == MotionActivity.Off);
      if (offSlices.isNotEmpty) {
        offMinutes = offSlices
            ?.map((slice) => slice.minutes)
            ?.reduce((curr, next) => curr + next);
      }

      final unknownSlices =
          places?.where((p) => p.activity == MotionActivity.Unknown);
      if (unknownSlices.isNotEmpty) {
        unknownMinutes = unknownSlices
            ?.map((slice) => slice.minutes)
            ?.reduce((curr, next) => curr + next);
      }

      print('[GeneriUtils] offMinutes : $offMinutes');

      // TODO leggere anche gli id dei precedenti luoghi intesi come "CASA"
      // altrimenti cambianddo casa l algo non riconosce i luoghi impostati
      // come CASA nei giorni passati
      final homeIdentifier = Hive.box('user').get(homeGeofenceKey);

      int homeMinutes = 0;
      if (homeIdentifier != null) {
        final homeSlices =
            places.where((p) => p.places.contains(homeIdentifier));
        if (homeSlices.isNotEmpty) {
          homeMinutes = homeSlices
              .map((slice) => slice.minutes)
              .reduce((curr, next) => curr + next);
        }
      }
      final onMinutes = 1440 - offMinutes - unknownMinutes;
      if (onMinutes < 0) {
        throw Exception('[GeneriUtils] onMinites cannont to be less that zero');
      }

      int onWom = (onMinutes / 60.0).ceil();
      int homeWom = (homeMinutes / 60.0).ceil();
      int wom = onWom;
      if (homeWom > 12) {
        int tmp = homeWom - 12;
        tmp *= 2;
        wom = onWom + tmp;
      }

      print(
          '[DayNotifier] homeMinutes : $homeMinutes, offMinutes $offMinutes, onMinutes: $onMinutes. WOM $wom');

      return wom;
    } catch (ex) {
      print('[DayNotifier] [ERROR] getWomCountForThisDay() $ex');
      return -1;
    }
  }
}
