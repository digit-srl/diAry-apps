import 'package:diary/application/day_notifier.dart';
import 'package:diary/application/upload_stats/upload_stats_notifier.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:diary/presentation/widgets/info_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/presentation/pages/settings/settings_page.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import '../logs_page.dart';
import '../slices_page.dart';
import 'widgets/activation_card.dart';
import 'widgets/daily_stats.dart';
import 'widgets/gps_card.dart';
import 'package:provider/provider.dart';
import 'package:diary/utils/extensions.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 65, 16, 0),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: <Widget>[
              DailyStatsWidget(),
              SizedBox(
                height: 5,
              ),
//              CarCard(),
              GpsCard(),
              ActivationCard(),
//              PlaceLegend(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 15,
        color: Colors.white,
        child: Container(
          height: 60 + MediaQuery.of(context).padding.bottom,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF2F7),
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/wom_pin.png',
                            width: 25,
                          ),
                          Text(
                            context.select((DayState value) =>
                                value?.day?.wom != null
                                    ? value.day.wom.toString()
                                    : '-'),
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  UploadStatsIconButton(),
                  IconButton(
                    icon: Icon(Icons.list),
                    color: accentColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => TabBarDemo(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: accentColor,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.bug_report),
                    color: accentColor,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LogsPage(),
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

class UploadStatsIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final day = context.watch<DayState>().day;
    final response = day.dailyStatsResponse;
    final isToday = day.date.isToday();
    final isStatsSended = day.isStatsSended;

    return IconButton(
      icon: isStatsSended
          ? Container(
//              height: 30,
              child: Image.asset(
                'assets/wom_pocket_logo.png',
              ),
            )
          : Icon(isToday ? Icons.cloud_off : Icons.cloud_upload),
      color: accentColor,
      iconSize: 30,
      onPressed: () => uploadStats(context, response),
    );
  }

  uploadStats(BuildContext context, DailyStatsResponse response) async {
    final dailyStats = await context.read<DayNotifier>().buildDailyStats();

    await showSlidingBottomSheet(
      context,
      useRootNavigator: true,
      builder: (context) {
        return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          duration: Duration(milliseconds: 300),
          minHeight: MediaQuery.of(context).size.height * 0.9,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.9],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return StateNotifierProvider(
              create: (BuildContext context) =>
                  UploadStatsNotifier(dailyStats, response),
              child: Material(
                child: InfoStatsWidget(
                  dailyStats: dailyStats,
                ),
              ),
            );
          },
        );
      },
    );

//                      either.fold((failure) {
//                        Alert(
//                          context: context,
//                          title: 'Errore',
//                          desc:
//                              '${failure is UnknownFailure ? failure.message : failure}',
//                          buttons: [
//                            DialogButton(
//                              child: Text('Ok'),
//                              onPressed: () {
//                                Navigator.of(context).pop();
//                              },
//                            ),
//                          ],
//                        ).show();
//                      }, (DailyStatsResponse response) {
//                        Alert(
//                          context: context,
//                          title: 'Complimenti',
//                          desc:
//                              '${response.womLink} |||| ${response.womPassword}',
//                          buttons: [
//                            DialogButton(
//                              child: Text('Grazie'),
//                              onPressed: () {
//                                Navigator.of(context).pop();
//                              },
//                            ),
//                            DialogButton(
//                              child: Text('Apri WOM Pocket'),
//                              onPressed: () {
//                                Navigator.of(context).pop();
//                              },
//                            ),
//                          ],
//                        ).show();
//                      });
  }
}
