import 'dart:io';

import 'package:diary/application/call_to_action/call_to_action_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/root_elevation_notifier.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/infrastructure/repositories/location_repository_impl.dart';
import 'package:diary/infrastructure/repositories/user_repository_impl.dart';
import 'package:diary/presentation/pages/home/widgets/cards/beta_card.dart';
import 'package:diary/presentation/pages/home/widgets/cards/gps_card.dart';
import 'package:diary/presentation/pages/home/widgets/cards/my_places_card.dart';
import 'package:diary/presentation/pages/home/widgets/cards/tracking_card.dart';
import 'package:diary/utils/alerts.dart';
import 'package:diary/utils/bottom_sheets.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/application/day_notifier.dart';
import 'package:diary/application/upload_stats/upload_stats_notifier.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:diary/presentation/widgets/info_stats_widget.dart';
import 'package:diary/utils/import_export_utils.dart';
import 'package:diary/utils/logger.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:diary/presentation/pages/settings/settings_page.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'widgets/call_to_action_widget.dart';
import 'widgets/daily_stats.dart';
import 'package:diary/utils/extensions.dart';

class NoRippleOnScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _controller;
  final double elevationOn = 4;
  final double elevationOff = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    Provider.of<RootElevationNotifier>(context, listen: false)
        .changeElevationIfDifferent(0, 0);
  }

  void _scrollListener() {
    double newElevation = _controller.offset > 1 ? elevationOn : elevationOff;
    Provider.of<RootElevationNotifier>(context, listen: false)
        .changeElevationIfDifferent(0, newElevation);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoRippleOnScrollBehavior(),
        child: ListView(
          controller: _controller,
          children: <Widget>[
            SizedBox(
              // top padding calcolato in relazione alla toolbar (non c'è
              // bisogno di considerare la statusbar, grazie allo scaffold);
              // -16 compensa il padding naturale del grafico
              height: kToolbarHeight - 16,
            ),
            DailyStatsWidget(),
            // CarCard(),
            GpsCard(),
            TrackingCard(),
//            BetaCard(),
            MyPlacesCard(),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 16,
        color: Theme.of(context).primaryColor,
        child: Container(
          height: 60 + MediaQuery.of(context).padding.bottom,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      //border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/wom_pin.png',
                            color: Theme.of(context).iconTheme.color,
                            width: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            context.select((DayState value) =>
                                value?.day?.wom != null
                                    ? value.day.wom.toString()
                                    : '-'),
                            style: Theme.of(context).textTheme.body2,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  UploadStatsIconButton(),
                  CallToActionIconButton(),
                  IconButton(
                    icon: Icon(Icons.file_download),
                    tooltip: "Esporta CSV/JSON",
                    onPressed: () {
                      ImportExportUtils.exportAllData(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    tooltip: "Impostazioni",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CallToActionIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final day = context.watch<DayState>().day;
//    final response = day.dailyStatsResponse;
//    final isToday = day.date.isToday;
//    final isStatsSended = day.isStatsSended;

    return IconButton(
      icon: Icon(
        CustomIcons.hospital_box_outline,
      ),
      onPressed: () {
        showCallToActionBottomSheet(context);
      },
      tooltip: "Notifica sanitaria",
    );
  }

  showCallToActionBottomSheet(BuildContext context) async {
    BottomSheets.showFullPageBottomSheet(
        context,
        StateNotifierProvider(
          create: (BuildContext context) => CallToActionNotifier(
              context.read<LocationRepositoryImpl>(),
              context.read<UserRepositoryImpl>())
            ..loadCalls(),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CallToActionWidget(),
          ),
        ));
  }
}

class UploadStatsIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final day = context.watch<DayState>().day;
    final response = day.dailyStatsResponse;
    final isToday = day.date.isToday;
    final isStatsSended = day.isStatsSended;

    return IconButton(
      tooltip: "Condividi statistiche e riscatta WOM",
      icon: isStatsSended
          ? Container(
//              height: 30,
              child: Image.asset(
                'assets/wom_pocket_logo.png',
                color: Theme.of(context).iconTheme.color,
              ),
            )
          : Icon(
              isToday ? Icons.cloud_off : CustomIcons.cloud_upload_outline,
            ),
      onPressed: () => showInfoStatsBottomSheet(context, response),
    );
  }

  showInfoStatsBottomSheet(
      BuildContext context, DailyStatsResponse response) async {
    final dailyStats = await context.read<DayNotifier>().buildDailyStats();

    BottomSheets.showFullPageBottomSheet(
        context,
        StateNotifierProvider(
          create: (BuildContext context) =>
              UploadStatsNotifier(dailyStats, response),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: InfoStatsWidget(
              dailyStats: dailyStats,
            ),
          ),
        ));
  }
}
