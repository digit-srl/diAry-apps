import 'dart:io';

import 'package:diary/application/current_root_page_notifier.dart';
import 'package:diary/application/day_notifier.dart';
import 'package:diary/application/gps_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/infrastructure/data/daily_stats_local_data_sources.dart';
import 'package:diary/infrastructure/data/daily_stats_remote_data_sources.dart';
import 'package:diary/infrastructure/data/user_local_data_sources.dart';
import 'package:diary/domain/repositories/user_repository.dart';
import 'package:diary/infrastructure/repositories/daily_stats_repository_impl.dart';
import 'package:diary/application/root_elevation_notifier.dart';
import 'package:diary/main.dart';
import 'package:diary/presentation/widgets/main_fab_button.dart';
import 'package:diary/utils/app_theme.dart';
import 'package:diary/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/geofence_event_notifier.dart';
import 'package:diary/presentation/pages/root/root_page.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorndial/unicorndial.dart';
import 'application/annotation_notifier.dart';
import 'application/app_provider.dart';
import 'application/geofence_notifier.dart';
import 'application/location_notifier.dart';
import 'application/motion_activity_notifier.dart';
import 'application/date_notifier.dart';
import 'application/service_notifier.dart';
import 'domain/entities/location.dart';
import 'domain/repositories/daily_stats_repository.dart';
import 'infrastructure/repositories/location_repository_impl.dart';
import 'infrastructure/repositories/user_repository_impl.dart';
import 'package:provider/provider.dart';

import 'domain/entities/day.dart';

/// Main widget of the application. It initializes providers, and the first
/// build layer with the custom FAB. It is necessary to keep it separated by the
/// root page, to avoid state changes on the FAB, during page change.
class DiAryApp extends StatefulWidget {
  final Map<DateTime, List<Location>> locationsPerDate;
  final Map<DateTime, Day> days;

  const DiAryApp({Key key, this.locationsPerDate, this.days}) : super(key: key);

  @override
  _DiAryAppState createState() => _DiAryAppState();
}

class _DiAryAppState extends State<DiAryApp> {
  ServiceNotifier serviceNotifier;
//  DayNotifier dayNotifier;
  UserRepository userRepository;
  DailyStatsRepository dailyStatsRepository;
  final GlobalKey<UnicornDialerState> _dialerKey =
      GlobalKey<UnicornDialerState>(debugLabel: 'prova');

  @override
  void initState() {
    super.initState();
    userRepository =
        UserRepositoryImpl(UserLocalDataSourcesImpl(Hive.box('user')));
//    dailyStatsRepository = DailyStatsRepositoryImpl(
//        DailyStatsLocalDataSourcesImpl(Hive.box('dailyStatsResponse')),
//        DailyStatsRemoteDataSourcesImpl());
    serviceNotifier = ServiceNotifier();
//    dayNotifier = DayNotifier(widget.days);
    if (Platform.isAndroid) requestIgnoreBatteryOptimization();
  }

  requestIgnoreBatteryOptimization() async {
    try {
      PermissionStatus permissionStatus = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.ignoreBatteryOptimizations);
      if (permissionStatus == PermissionStatus.denied) {
        await PermissionHandler()
            .requestPermissions([PermissionGroup.ignoreBatteryOptimizations]);
      }
    } catch (ex) {
      print('[App] Error requestIgnoreBatteryOptimization');
      print(ex);
      analytics.logEvent(
          name: 'Error Ignore Optimization Battery',
          parameters: {'error': ex.toString()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (BuildContext context) => AppProvider(serviceNotifier),
          lazy: false,
        ),
        Provider<UserRepositoryImpl>.value(
          value: userRepository,
        ),
        Provider<DailyStatsRepositoryImpl>(
          create: (_) => DailyStatsRepositoryImpl(
            DailyStatsLocalDataSourcesImpl(Hive.box('dailyStatsResponse')),
            DailyStatsRemoteDataSourcesImpl(),
          ),
        ),
        StateNotifierProvider<AnnotationNotifier, AnnotationState>(
          create: (_) => AnnotationNotifier(
              Hive.box<Annotation>('annotations').values.toList()),
        ),
        StateNotifierProvider<DateNotifier, DateState>(
          create: (_) => DateNotifier(),
        ),
        StateNotifierProvider<DayNotifier, DayState>(
          create: (_) =>
              DayNotifier(widget.days, context.read<LocationRepositoryImpl>()),
          lazy: false,
        ),
        StateNotifierProvider<ServiceNotifier, ServiceState>.value(
          value: serviceNotifier,
        ),
        StateNotifierProvider<LocationNotifier, LocationState>(
          create: (_) => LocationNotifier(widget.locationsPerDate),
        ),
        StateNotifierProvider<MotionActivityNotifier, MotionActivityState>(
          create: (_) => MotionActivityNotifier(),
        ),
        StateNotifierProvider<GeofenceNotifier, GeofenceState>(
          create: (_) => GeofenceNotifier(userRepository),
        ),
        StateNotifierProvider<GeofenceEventNotifier, GeofenceEventState>(
          create: (_) => GeofenceEventNotifier(),
        ),
//        StateNotifierProvider<GeofenceChangeNotifier, GeofenceChangeState>(
//          create: (_) => GeofenceChangeNotifier(),
//        ),
        StateNotifierProvider<GpsNotifier, GpsState>(
          create: (_) => GpsNotifier(),
        ),
        StateNotifierProvider<RootElevationNotifier, ElevationState>(
          create: (_) => RootElevationNotifier(),
        ),
        StateNotifierProvider<CurrentRootPageNotifier, CurrentRootPageState>(
          create: (_) => CurrentRootPageNotifier(),
        ),
      ],
      child: MaterialApp(
        // locale: DevicePreview.of(context).locale, // <--- Add the locale
        // builder: DevicePreview.appBuilder,        // <--- Add the builder
        title: 'diAry',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme, // <--- Handles dark theme
        home: WillPopScope(
          onWillPop: () {
            return handleBackButtonWithFab(_dialerKey);
          },
          child: Scaffold(
            body: RootPage(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: MainFabButton(dialerKey: _dialerKey),
//            floatingActionButton: Builder(
//              builder: (ctx) {
//                return FloatingActionButton(
//                  backgroundColor: Colors.yellow,
//                  onPressed: () async {
//                    final result = await ctx
//                        .read<LocationRepositoryImpl>()
//                        .getLocationsBetween(
//                            DateTime(2020, 4, 21, 0, 0), DateTime.now());
//                    result.fold(
//                      (f) => logger(f),
//                      (locs) => logger(locs.length),
//                    );
//                  },
//                );
//              },
//            ),
          ),
        ),
      ),
    );
  }

  // should handle back button click wje
  Future<bool> handleBackButtonWithFab(
      GlobalKey<UnicornDialerState> dialerKey) {
    final isFabExpanded = dialerKey.currentState.close();
    logger.i("Handle back button FAB. Expanded? " + isFabExpanded.toString());

    if (isFabExpanded) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  void dispose() {
    serviceNotifier.dispose();
//    dayNotifier.dispose();
    super.dispose();
  }
}
