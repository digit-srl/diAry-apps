import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/day_notifier.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:diary/presentation/widgets/custom_icons_icons.dart';
import 'package:diary/utils/place_utils.dart';
import 'package:flutter/material.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:diary/utils/extensions.dart';

class DailyStatsLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<DayState>(
      stateNotifier: context.watch<DayNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        Set<Place> places;
        /*
        essendo in questo modo la scheda di sola lettura, vengono mostrate tutte anche se si è nel giorno oggi
        if (value.day.date.isToday()) {
          places = Hive.box<Place>('places')
              .values
              .where((place) => place.enabled == true)
              .toSet();
        } else {
          places = value.day.geofences;
        }*/
        places = value.day.geofences;

        /*if (places.isEmpty) {
          return Container(
            height: 160,
            child: Center(
                child: Text('Non ci sono luoghi salvati per questo giorno')),
          );
        }*/
        return Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Legenda del grafico',
                style: titleCardStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "L'anello più esterno del grafico mostra gli spostamenti della giornata. Il colore blu rappresenta un generico spostamento.",
                style: secondaryStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "L'anello più interno mostra le segnalazioni piazzate durante la giornata.",
                style: secondaryStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "L'anello centrale del grafico mostra gli i luoghi nei quali si è sostato. Nella giornata di riferimento, si è passato per i seguenti luoghi:",
                style: secondaryStyle,
              ),
              SizedBox(
                height: 16,
              ),
              if (places.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: baseCard,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: <Widget>[
                      if (places.isNotEmpty)
                        for (Place place in places)
                          PlaceRowDailyLegend(
                            title: place.name,
                            isHome: place.isHome,
                            pinColor: Color(place.color),
                            geoRadius: "Raggio: " +
                                place.radius.toInt().toString() +
                                " metri",
                            lastLine: place == places.last,
                            location:
                                'Lat: ${place.latitude.toStringAsFixed(2)} Long: ${place.longitude.toStringAsFixed(2)}',
                            onRemove: () {
                              PlaceUtils.removePlace(context, place.identifier);
                            },
                          )
                    ],
                  ),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: baseCard,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Non ci sono luoghi da visualizzare per questa giornata.",
                        style: secondaryStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PlaceRowDailyLegend extends StatelessWidget {
  final String title;
  final String location;
  final String geoRadius;
  final Color pinColor;
  final Function onRemove;
  final bool lastLine;
  final bool isHome;

  const PlaceRowDailyLegend(
      {Key key,
      this.title,
      this.pinColor,
      this.location,
      this.geoRadius,
      this.onRemove,
      this.lastLine,
      this.isHome = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 48,
                height: 40,
                decoration: BoxDecoration(
                  color: pinColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isHome
                        ? CustomIcons.home_outline
                        : CustomIcons.map_marker_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: AutoSizeText(
                          title,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        child: AutoSizeText(
                          geoRadius, // location,
                          maxLines: 1,
                          style: secondaryStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*
              IconButton(
                icon: Icon(Icons.delete),
                color: accentColor,
                onPressed: onRemove,
              ),
              */
            ],
          ),
        ),
        if (!lastLine) Divider(height: 1)
      ],
    );
  }
}
