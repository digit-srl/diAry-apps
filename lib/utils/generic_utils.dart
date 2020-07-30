import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:diary/domain/entities/motion_activity.dart';
import 'package:diary/domain/entities/slice.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'logger.dart';

class GenericUtils {
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
    if (places.isEmpty) {
      return 0;
    }
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

      logger.i('[GeneriUtils] offMinutes : $offMinutes');

      // TODO leggere anche gli id dei precedenti luoghi intesi come "CASA"
      // altrimenti cambianddo casa l algo non riconosce i luoghi impostati
      // come CASA nei giorni passati
//      final homeIdentifier = Hive.box('user').get(homeGeofenceKey);

//      int homeMinutes = 0;
//      if (homeIdentifier != null) {
//        final homeSlices =
//            places.where((p) => p.places.contains(homeIdentifier));
//        if (homeSlices.isNotEmpty) {
//          homeMinutes = homeSlices
//              .map((slice) => slice.minutes)
//              .reduce((curr, next) => curr + next);
//        }
//      }
      final onMinutes = 1440 - offMinutes - unknownMinutes;
      if (onMinutes < 0) {
        throw Exception('[GeneriUtils] onMinites cannont to be less that zero');
      }

      int onWom = (onMinutes / 60.0).ceil();
//      int homeWom = (homeMinutes / 60.0).ceil();
      int wom = onWom;
//      if (homeWom > 12) {
//        int tmp = homeWom - 12;
//        tmp *= 2;
//        wom = onWom + tmp;
//      }

      logger.i(
          '[DayNotifier] offMinutes $offMinutes, onMinutes: $onMinutes. WOM $wom');
      return wom;
    } catch (ex) {
      logger.e('[DayNotifier] [ERROR] getWomCountForThisDay() $ex');
      return -1;
    }
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<bool> checkIfPocketIsInstalled() async {
    try {
      logger.i('checkIfPocketIsInstalled');

      bool isInstalled;
      if (Platform.isAndroid) {
        isInstalled = await DeviceApps.isAppInstalled('social.wom.pocket');
      } else {
        isInstalled = await canLaunch('1466969163://');
      }
      logger.i('installed $isInstalled');
      return isInstalled ?? false;
    } catch (ex, stackTrace) {
      print(ex);
      Crashlytics.instance.recordError(ex, stackTrace);
      return false;
    }
  }
}
