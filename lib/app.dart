import 'package:diary/application/day_notifier.dart';
import 'package:diary/application/gps_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/infrastructure/user_repository.dart';
import 'package:diary/presentation/widgets/main_fab_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/geofence_event_notifier.dart';
import 'package:diary/presentation/pages/root/root_page.dart';
import 'package:hive/hive.dart';
import 'package:unicorndial/unicorndial.dart';
import 'application/annotation_notifier.dart';
import 'application/app_provider.dart';
import 'application/geofence_notifier.dart';
import 'application/location_notifier.dart';
import 'application/motion_activity_notifier.dart';
import 'application/date_notifier.dart';
import 'application/service_notifier.dart';
import 'domain/entities/location.dart';
import 'presentation/widgets/track_shape.dart';
import 'utils/colors.dart';
import 'package:provider/provider.dart';

import 'domain/entities/day.dart';

class MyDayApp extends StatefulWidget {
  final Map<DateTime, List<Location>> locationsPerDate;
  final Map<DateTime, Day> days;

  const MyDayApp({Key key, this.locationsPerDate, this.days}) : super(key: key);

  @override
  _MyDayAppState createState() => _MyDayAppState();
}

class _MyDayAppState extends State<MyDayApp> {
  ServiceNotifier serviceNotifier;
//  DayNotifier dayNotifier;
  UserRepository userRepository;
  final GlobalKey<UnicornDialerState> dialerKey =
      GlobalKey<UnicornDialerState>(debugLabel: 'prova');
  @override
  void initState() {
    super.initState();
    userRepository = UserRepositoryImpl(Hive.box('user'));
    serviceNotifier = ServiceNotifier();
//    dayNotifier = DayNotifier(widget.days);
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
        StateNotifierProvider<AnnotationNotifier, AnnotationState>(
          create: (_) => AnnotationNotifier(
              Hive.box<Annotation>('annotations').values.toList()),
        ),
        StateNotifierProvider<DateNotifier, DateState>(
          create: (_) => DateNotifier(),
        ),
        StateNotifierProvider<DayNotifier, DayState>(
          create: (_) => DayNotifier(widget.days),
          lazy: false,
        ),
        StateNotifierProvider<ServiceNotifier, ServiceState>.value(
          value: serviceNotifier,
        ),
        StateNotifierProvider<LocationNotifier, LocationState>(
          create: (_) => LocationNotifier(widget.locationsPerDate, widget.days),
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
      ],
      child: MaterialApp(
//        locale: DevicePreview.of(context).locale, // <--- Add the locale
//        builder: DevicePreview.appBuilder, // <--- Add the builder
        title: 'diAry',
        theme: ThemeData(
          accentColor: accentColor,
          primaryColor: Colors.white,
          fontFamily: 'Nunito',
          scaffoldBackgroundColor: Colors.white,
          iconTheme: IconThemeData(color: accentColor),
          sliderTheme: SliderThemeData(
            trackShape: CustomTrackShape(),
            activeTrackColor: accentColor,
            inactiveTrackColor: Color(0xFFC0CCDA),
            inactiveTickMarkColor: Color(0xFFC0CCDA),
            thumbColor: accentColor,
            overlayColor: Color(0xFFC0CCDA).withOpacity(0.4),
            overlappingShapeStrokeColor: accentColor,
            valueIndicatorColor: accentColor,
          ),
        ),
        home: WillPopScope(
          onWillPop: () {
            final wasOpened = dialerKey.currentState.close();
            print(wasOpened);
            return Future.value(!wasOpened);
          },
          child: Scaffold(
            body: RootPage(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: MainFabButton(
              dialerKey: dialerKey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    serviceNotifier.dispose();
//    dayNotifier.dispose();
    super.dispose();
  }
}
