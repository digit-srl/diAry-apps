import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/root/date_notifier.dart';
import 'package:diary/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class MyDayAppBar extends StatefulWidget {
  final Function changePage;

  const MyDayAppBar({Key key, this.changePage}) : super(key: key);

  @override
  _MyDayAppBarState createState() => _MyDayAppBarState();
}

class _MyDayAppBarState extends State<MyDayAppBar> {
  int _currentPage = 0;

//  final rangeDate = [
//    DateTime(2020, 3, 7),
//    DateTime(2020, 3, 8),
//    DateTime(2020, 3, 10),
//    DateTime(2020, 3, 12),
//    DateTime(2020, 3, 13),
//    DateTime.now().withoutMinAndSec()
//  ];

  _MyDayAppBarState() {
//    rangeDate.forEach(print);
  }

  bool isMoving = false;

  @override
  Widget build(BuildContext context) {
    print('[AppBar] build()');
    final dates = Provider.of<LocationNotifier>(context, listen: false).dates;

    return Container(
      color: Colors.white.withOpacity(0.4),
      height: 60,
      padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: Icon(_currentPage == 0 ? Icons.map : Icons.arrow_back),
              onPressed: () {
                widget.changePage(_currentPage == 0 ? 1 : 0);
                setState(() {
                  _currentPage = _currentPage == 0 ? 1 : 0;
                });
              }),
          GestureDetector(
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: Provider.of<DateState>(context, listen: false)
                    .selectedDate
                    .withoutMinAndSec(),
                firstDate: dates.first,
                lastDate: dates.last.add(Duration(minutes: 1)),
                selectableDayPredicate: (DateTime date) => dates.contains(
                  date.withoutMinAndSec(),
                ),
              );

              if (selected == null) return;
              Provider.of<DateNotifier>(context, listen: false)
                  .changeSelectedDate(selected);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 35,
                ),
                Text(
                  context.select((DateState value) =>
                      value.isToday ? 'Oggi' : value.dateFormatted),
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
//          IconButton(
//              icon: Icon(Icons.change_history),
//              onPressed: () {
//                Provider.of<ServiceNotifier>(context, listen: false)
//                    .invertEnabled();
//                Provider.of<LocationNotifier>(context, listen: false)
//                    .addLocation(null);
//              }),
//          IconButton(
//              color: isMoving ? Colors.green : Colors.red,
//              icon: Icon(Icons.directions_walk),
//              onPressed: () {
//                bg.BackgroundGeolocation.changePace(!isMoving);
//                setState(() {
//                  isMoving = !isMoving;
//                });
//              }),
          IconButton(
            icon: Icon(_currentPage == 0
                ? Icons.collections_bookmark
                : _currentPage == 1 ? Icons.gps_fixed : Icons.search),
            onPressed: () {
              if (_currentPage == 1) {
                getCurrentLoc();
              } else {
                widget.changePage(2);
                setState(() {
                  _currentPage = 2;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  getCurrentLoc() {
    bg.BackgroundGeolocation.getCurrentPosition(
        persist: true,
        // <-- do not persist this location
        desiredAccuracy: 40,
        // <-- desire an accuracy of 40 meters or less
        maximumAge: 10000,
        // <-- Up to 10s old is fine.
        timeout: 30,
        // <-- wait 30s before giving up.
        samples: 3,
        // <-- sample just 1 location
        extras: {"getCurrentPosition": true}).then((bg.Location location) {
      print('[getCurrentPosition] - $location');
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }
}
