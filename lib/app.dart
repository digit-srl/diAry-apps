import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/geofence_notifier.dart';
import 'package:diary/presentation/pages/root/root_page.dart';
import 'application/app_provider.dart';
import 'application/geofence_change_notifier.dart';
import 'application/location_notifier.dart';
import 'application/motion_activity_notifier.dart';
import 'application/root/date_notifier.dart';
import 'application/service_notifier.dart';
import 'colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg show Location;

import 'domain/entities/day.dart';

class MyDayApp extends StatefulWidget {
  final Map<DateTime, List<bg.Location>> locationsPerDate;
  final Map<DateTime, Day> days;

  const MyDayApp({Key key, this.locationsPerDate, this.days}) : super(key: key);

  @override
  _MyDayAppState createState() => _MyDayAppState();
}

class _MyDayAppState extends State<MyDayApp> {
  ServiceNotifier serviceNotifier;

  @override
  void initState() {
    super.initState();
    serviceNotifier = ServiceNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (BuildContext context) => AppProvider(serviceNotifier),
          lazy: false,
        ),
        StateNotifierProvider<DateNotifier, DateState>(
          create: (_) => DateNotifier(),
        ),
        StateNotifierProvider<LocationNotifier, LocationState>(
          create: (_) => LocationNotifier(widget.locationsPerDate, widget.days),
        ),
        StateNotifierProvider.value(
          value: serviceNotifier,
        ),
        StateNotifierProvider<MotionActivityNotifier, MotionActivityState>(
          create: (_) => MotionActivityNotifier(),
        ),
        StateNotifierProvider<GeofenceNotifier, GeofenceState>(
          create: (_) => GeofenceNotifier(),
        ),
        StateNotifierProvider<GeofenceChangeNotifier, GeofenceChangeState>(
          create: (_) => GeofenceChangeNotifier(),
        ),
      ],
      child: MaterialApp(
        locale: DevicePreview.of(context).locale, // <--- Add the locale
        builder: DevicePreview.appBuilder, // <--- Add the builder
        title: 'Flutter Demo',
        theme: ThemeData(
            accentColor: accentColor,
            primaryColor: Colors.white,
            fontFamily: 'Nunito',
            scaffoldBackgroundColor: Colors.white,
            iconTheme: IconThemeData(color: accentColor)),
        home: RootPage(),
      ),
    );
  }

  @override
  void dispose() {
    serviceNotifier.dispose();
    super.dispose();
  }
}
