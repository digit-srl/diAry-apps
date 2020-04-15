import 'package:diary/application/upload_stats/upload_stats_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
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
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Opacity(
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(Icons.clear),
                color: Colors.white,
                iconSize: 24.0,
                onPressed: null,
              ),
              opacity: 0.0,
            ),
            Spacer(),
            Text(
              'Caricamento statistiche',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(Icons.clear),
                color: Colors.black,
                iconSize: 24.0,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ),
        Divider(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              StatText('Data: ', dailyStats.formattedDate),
              StatText('Minuti di servizio attivo: ',
                  dailyStats.totalMinutesTracked?.toString()),
              StatText('Centroide: ', dailyStats.centroidHash),
              StatText('Minuti a casa: ',
                  dailyStats.locationTracking.minutesAtHome?.toString()),
              StatText(
                  'Minuti passati in altri miei luoghi: ',
                  dailyStats.locationTracking.minutesAtOtherKnownLocations
                      ?.toString()),
              StatText('Minuti fuori dai miei luoghi: ',
                  dailyStats.locationTracking.minutesElsewhere?.toString()),
              StatText(
                  'Luoghi visitati: ', dailyStats.locationCount?.toString()),
              StatText(
                  'Numero di annotazioni: ', dailyStats.eventCount?.toString()),
              StatText('Campionamenti: ', dailyStats.sampleCount?.toString()),
              StatText('Campioni scartati: ',
                  dailyStats.discardedSampleCount?.toString()),
              StatText('Diagonale bb in metri: ',
                  dailyStats.boundingBoxDiagonal?.toStringAsFixed(2) ?? '-'),
              StateNotifierBuilder<UploadStatsState>(
                stateNotifier: context.read<UploadStatsNotifier>(),
                builder: (contest, state, child) {
                  return state.map(
                    initial: (_) {
                      if (dailyStats.date.isToday()) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          height: 200,
                          child: Card(
                            elevation: 4.0,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
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
                        child: Center(
                          child: CircularProgressIndicator(),
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
  final TextStyle textStyle = const TextStyle(fontSize: 18);
  const StatText(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text.rich(
        TextSpan(
          text: label,
          children: [
            TextSpan(
              text: value,
              style: textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        style: textStyle,
      ),
    );
  }
}

class ErrorResponseWidget extends StatelessWidget {
  final String error;

  const ErrorResponseWidget({Key key, @required this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      height: 200,
      child: Card(
        elevation: 4.0,
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
                  style: TextStyle(fontWeight: FontWeight.w600),
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
    final link = _dailyStatsResponse.womLink;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: Card(
              elevation: 4.0,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Complimenti! Hai ottenuto',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _dailyStatsResponse.womCount.toString(),
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/wom_pin.png',
                            height: 70,
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
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Pin: ',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text: _dailyStatsResponse.womPassword,
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
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
            height: 20,
          ),
          Row(
            children: <Widget>[
              GenericButton(
                text: 'Lo farò in seguito',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Spacer(),
              GenericButton(
                text: 'Apri il Pocket',
                color: Color(0xFF0877E5),
                onPressed: () {
                  _launchURL(_dailyStatsResponse.womLink);
                },
              ),
            ],
          ),
        ],
      ),
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
