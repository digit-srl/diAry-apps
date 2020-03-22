import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diary/location_utils.dart';
import 'app.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:diary/extensions.dart';

import 'domain/entities/day.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

//  final List<bg.Location> locations = List<bg.Location>.unmodifiable(
//      (await bg.BackgroundGeolocation.locations)
//          .map((map) => bg.Location(map))
//          .toList());

//  final today = DateTime.now().withoutMinAndSec();
//  final todayDate = Day(
//    date: today,
//    slices: [
//      Slice(
//        minutes: 570,
//        startTime: today,
//
//        activity: MotionActivity.Still,
//      ),
//      Slice(
//        minutes: 1440 - 570,
//        startTime: today.copyWith(hour: 9, minute: 30),
//
//        activity: MotionActivity.Unknown,
//      ),
//    ],
//    notes: [
//      Note(
//        id: '2',
//        dateTime: DateTime.now().subtract(Duration(hours: 2)),
//      ),
//      Note(
//        id: '1',
//        dateTime: DateTime.now(),
//      ),
//      Note(
//        id: '3',
//        dateTime: DateTime.now().add(Duration(hours: 2)),
//      ),
//    ],
//    pointCount: 2,
//  );
//  final fakeTodayDate =  <DateTime, Day>{
//    today: todayDate,
//  };

  final Map<DateTime, List<bg.Location>> locationsPerDate =
      await LocationUtils.readAndFilterLocationsPerDay();
  final days = LocationUtils.aggregateLocationsInDayPerDate(locationsPerDate);

  final today = DateTime.now().withoutMinAndSec();
  if (!days.containsKey(today)) {
    days[today] = Day(date: today);
  }

  runApp(
//    MyDayApp(locationsPerDate: locationsPerDate, days: days),
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>
          MyDayApp(locationsPerDate: locationsPerDate, days: days),
    ),
  );
}
