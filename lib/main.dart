import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'app.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:diary/utils/extensions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'domain/entities/annotation.dart';
import 'domain/entities/day.dart';
import 'domain/entities/location.dart';
import 'domain/entities/place.dart';

BitmapDescriptor currentPositionMarkerIcon;
BitmapDescriptor annotationPositionMarkerIcon;
BitmapDescriptor pinPositionMarkerIcon;
BitmapDescriptor selectedPinMarkerIcon;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
//  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
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

  await Hive.initFlutter();
  Hive.registerAdapter(AnnotationAdapter());
  Hive.registerAdapter(PlaceAdapter());
  await Hive.openBox<String>('logs');
  await Hive.openBox('user');
  await Hive.openBox<Annotation>('annotations');
  final box = await Hive.openBox<Place>('places');
  box.values.forEach(print);
  final Map<DateTime, List<Location>> locationsPerDate =
      await LocationUtils.readAndFilterLocationsPerDay();
  final days = LocationUtils.aggregateLocationsInDayPerDate(locationsPerDate);

  final today = DateTime.now().withoutMinAndSec();
  if (!days.containsKey(today)) {
    days[today] = Day(date: today);
  }

  runApp(
      // i campi di status e navigation bar a volte diventano bianchi.
      // annotatedRegion in questa configurazione risolve il bug
      // https://github.com/flutter/flutter/issues/21265#issuecomment-500142587
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MyDayApp(locationsPerDate: locationsPerDate, days: days),
//    DevicePreview(
//      enabled: !kReleaseMode,
//      builder: (context) =>
//          MyDayApp(locationsPerDate: locationsPerDate, days: days),
//    ),
      ),
  );
}