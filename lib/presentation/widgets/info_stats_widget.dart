import 'package:diary/application/upload_stats_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/bottom_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:diary/domain/entities/daily_stats.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diary/utils/extensions.dart';

class InfoStatsWidget extends StatelessWidget {
  final DailyStats dailyStats;

  const InfoStatsWidget({Key key, this.dailyStats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardBottomSheetColumn(
      children: <Widget>[
          Text(
            'Caricamento statistiche',
            style: Theme.of(context).textTheme.headline,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Da questa schermata è possibile caricare nel database a disposizione "
            "delle autorità sanitarie le seguenti statistiche anonime di utilizzo. "
            "Le statistiche possono essere caricate solo dopo aver concluso una "
            "giornata di utilizzo (quindi dopo la mezzanotte). Il contributo "
            "verrà ricompensato tramite WOM.",
            style: Theme.of(context).textTheme.body1,
          ),
          SizedBox(
            height: 16,
          ),
         Column(
              children: <Widget>[
                StatText(
                    'Data',
                    dailyStats.formattedDate
                ),
                StatText(
                    'Minuti di servizio attivo',
                    dailyStats.totalMinutesTracked?.toString()
                ),
                StatText(
                    'Centroide: ',
                    dailyStats.centroidHash
                ),
                StatText(
                    'Minuti a casa',
                    dailyStats.locationTracking.minutesAtHome?.toString()
                ),
                StatText(
                    'Minuti passati in altri miei luoghi',
                    dailyStats.locationTracking.minutesAtOtherKnownLocations
                        ?.toString()
                ),
                StatText(
                    'Minuti fuori dai miei luoghi',
                    dailyStats.locationTracking.minutesElsewhere?.toString()
                ),
                StatText(
                    'Luoghi visitati',
                    dailyStats.locationCount?.toString()
                ),
                StatText(
                    'Numero di annotazioni',
                    dailyStats.eventCount?.toString()
                ),
                StatText(
                    'Campionamenti',
                    dailyStats.sampleCount?.toString(),
                ),
                StatText(
                    'Campioni scartati',
                    dailyStats.discardedSampleCount?.toString()
                ),
                StatText(
                    'Diagonale bb in metri',
                    dailyStats.boundingBoxDiagonal?.toStringAsFixed(2),
                    true
                ),
                SizedBox(height: 16),
                StateNotifierBuilder<UploadStatsState>(
                  stateNotifier: context.read<UploadStatsNotifier>(),
                  builder: (contest, state, child) {
                    return state.map(
                      initial: (_) {
                        if (dailyStats.date.isToday()) {
                          return Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.warning,
                                        color: Colors.orange,
                                        size: 60,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'I dati statistici possono essere\ninviati solo a giornata conclusa',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1),
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GenericButton(
                            text: 'Carica i dati',
                            onPressed: () => _sendDailyStats(context),
                          ),
                        );
                      },
                      loading: (_) {
                        return Container(
                          height: 200,
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        );
                      },
                      error: (error) {
                        return ErrorResponseWidget(error: error.message);
                      },
                      womResponse: (response) {
                        return WomResponseWidget(response.value);
                      },
                    );
                  },
                )
              ],
          ),
        ],
    );
  }

  _sendDailyStats(BuildContext context) {
    context.read<UploadStatsNotifier>().sendDailyStats(dailyStats);
  }
}

class StatText extends StatelessWidget {
  final String label;
  final String value;
  final bool lastLine;
  final TextStyle textStyle = const TextStyle(fontSize: 18);
  const StatText(this.label, this.value, [this.lastLine = false]);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    label ?? "-",
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
                Text(
                    value  ?? "-",
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontWeight: FontWeight.bold))
              ],
            ),
            if(!lastLine) Divider()
          ],
        ));
  }
}

class ErrorResponseWidget extends StatelessWidget {
  final String error;

  const ErrorResponseWidget({Key key, @required this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      error,
                      style: Theme.of(context).textTheme.body1,
                      textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class WomResponseWidget extends StatelessWidget {
  final DailyStatsResponse _dailyStatsResponse;

  const WomResponseWidget(this._dailyStatsResponse);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Complimenti! Hai ottenuto',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.body2
                        .copyWith(fontSize: 20),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _dailyStatsResponse.womCount.toString(),
                        style: Theme.of(context).textTheme.body2
                            .copyWith(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/wom_pin.png',
                          color: Theme.of(context).iconTheme.color,
                          height: 60,
                        ),
                      ),
                    ],
                  ),
//                    Container(
//                      color: Colors.red,
//                      height: 40,
//                      child: AutoSizeText(
////                        '${_dailyStatsResponse.womLink}',
//                        link,
////                        'https://dev.wom.social/vouchers',
//                        maxLines: 1,
//                        textAlign: TextAlign.center,
//                        style: TextStyle(
//                            fontSize: 30, fontWeight: FontWeight.bold),
//                      ),
//                    ),
                  SizedBox(
                    height: 16,
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Pin: ',
                      style: Theme.of(context).textTheme.body2
                          .copyWith(fontSize: 35, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: _dailyStatsResponse.womPassword,
                          style:Theme.of(context).textTheme.body2
                              .copyWith(fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            GenericButton(
              withBorder: false,
              text: 'Lo farò in seguito',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Spacer(),
            GenericButton(
              text: 'Apri il Pocket',
              onPressed: () {
                _launchURL(_dailyStatsResponse.womLink);
              },
            ),
          ],
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
