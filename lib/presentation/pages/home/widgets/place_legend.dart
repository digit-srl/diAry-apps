import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/day_notifier.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:flutter/material.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:diary/utils/extensions.dart';

class PlaceLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<DayState>(
      stateNotifier: context.watch<DayNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        Set<Place> places = {};
        if (value.day.date.isToday()) {
          places.addAll(Hive.box<Place>('places')
              .values
              .where((place) => place.enabled == true)
              .toSet());
        }
        places.addAll(value.day.geofences);

        if (places.isEmpty) {
          return Container(
            height: 150,
            child: Center(
                child: Text('Non ci sono luoghi salvati per questo giorno')),
          );
        }
        return Container(
//      height: 200,
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Color(0xFFEFF2F7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
//          mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Luoghi',
                style: titleCardStyle,
              ),
              SizedBox(
                height: 10,
              ),
              for (Place place in places)
                PlaceRowLegend(
                  title: place.name,
                  isHome: place.isHome,
                  enabled: place.enabled,
                  pinColor: Color(place.color),
                  location:
                      'Lat: ${place.latitude?.toStringAsFixed(2)} Long: ${place.longitude?.toStringAsFixed(2)}',
//                  onRemove: () {
//                    PlaceUtils.removePlace(context, place.identifier);
//                  },
                ),
            ],
          ),
        );
      },
    );
  }

//  _onRemove(BuildContext context, String identifier) {
//    final homeIdentifier =
//        Provider.of<UserRepositoryImpl>(context, listen: false)
//            .getHomeGeofenceIdentifier();
//    showPlatformDialog(
//      context: context,
//      builder: (_) => BasicDialogAlert(
//        title: Text("Sicuro di voler cancellare questo luogo?"),
//        actions: <Widget>[
//          BasicDialogAction(
//            title: Text("Si"),
//            onPressed: () {
//              Provider.of<GeofenceNotifier>(context, listen: false)
//                  .removeGeofence(identifier);
//              if (identifier == homeIdentifier) {
//                Provider.of<UserRepositoryImpl>(context, listen: false)
//                    .removeHomeGeofence();
//              }
//              Navigator.pop(context);
//            },
//          ),
//          BasicDialogAction(
//            title: Text("No"),
//            onPressed: () {
//              Navigator.pop(context);
//            },
//          ),
//        ],
//      ),
//    );
//  }
}

class PlaceRowLegend extends StatelessWidget {
  final String title;
  final String location;
  final Color pinColor;
  final Function onRemove;
  final bool isHome;
  final bool enabled;

  const PlaceRowLegend({
    Key key,
    this.title,
    this.pinColor,
    this.location,
    this.onRemove,
    this.isHome = false,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                isHome ? Icons.home : Icons.person_pin,
                color: pinColor,
                size: 50,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
//                          color: Colors.grey,
                        child: AutoSizeText(
                          title,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        child: AutoSizeText(
                          location,
                          maxLines: 1,
                          style: secondaryStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              enabled ?? false
                  ? Icon(
                      Icons.remove_red_eye,
                      color: pinColor,
                      size: 30,
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          color: Colors.black,
          height: 1,
        ),
      ],
    );
  }
}
