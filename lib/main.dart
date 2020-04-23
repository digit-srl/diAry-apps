import 'package:device_preview/device_preview.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:diary/infrastructure/data/locations_local_data_sources.dart';
import 'package:diary/infrastructure/repositories/location_repository_impl.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'app.dart';
import 'package:diary/utils/extensions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'domain/entities/annotation.dart';
import 'domain/entities/day.dart';
import 'domain/entities/location.dart';
import 'domain/entities/place.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

BitmapDescriptor currentPositionMarkerIcon;
BitmapDescriptor annotationPositionMarkerIcon;
BitmapDescriptor pinPositionMarkerIcon;
BitmapDescriptor selectedPinMarkerIcon;
BitmapDescriptor genericPinMarkerIcon;

FirebaseAnalytics analytics = FirebaseAnalytics();

/// Entry point for the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  //  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  await Hive.initFlutter();
  Hive.registerAdapter(AnnotationAdapter());
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(DailyStatsResponseAdapter());
  await Hive.openBox<String>('logs');
  await Hive.openBox('user');
  await Hive.openBox<Annotation>('annotations');
  await Hive.openBox('dailyStatsResponse');
  await Hive.openBox<Place>('places');
  await Hive.openBox<String>('pinNotes');

  final repository = LocationRepositoryImpl(LocationsLocalDataSourcesImpl());
  final Map<DateTime, List<Location>> locationsPerDate =
      await repository.readAndFilterLocationsPerDay();
  final days = LocationUtils.aggregateLocationsInDayPerDate(locationsPerDate);

  final today = DateTime.now().withoutMinAndSec();
  if (!days.containsKey(today)) {
    days[today] = Day(date: today);
  }

  // makes the status bar in Android transparent. It is necessary to do it from
  // here. More overlay styles are handled inside the build tree, with
  // AnnotatedRegion, to keep them synchronized with day-night theme
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(
    Provider.value(
      value: repository,
      child: DiAryApp(locationsPerDate: locationsPerDate, days: days),
    ),
//    DevicePreview(
//      enabled: !kReleaseMode,
//      builder: (context) =>
//          DiAryApp(locationsPerDate: locationsPerDate, days: days),
//    ),
  );
}
