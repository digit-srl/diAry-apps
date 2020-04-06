import 'package:diary/application/day_notifier.dart';
import 'package:diary/application/gps_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/utils/extensions.dart';
import 'package:provider/provider.dart';

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

    return WillPopScope(
      onWillPop: () {
        if (_currentPage != 0) {
          widget.changePage(0);
          setState(() {
            _currentPage = 0;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Container(
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
                Provider.of<DayNotifier>(context, listen: false)
                    .changeDay(selected);
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
                        fontSize: 20,
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
//            IconButton(
//                color: isMoving ? Colors.green : Colors.red,
//                icon: Icon(Icons.directions_walk),
//                onPressed: () {
//                  bg.BackgroundGeolocation.changePace(!isMoving);
//                  isMoving = !isMoving;
////                  setState(() {
////
////                  });
//                }),
            IconButton(
              icon: Icon(_currentPage == 0
                  ? Icons.collections_bookmark
                  : _currentPage == 1 ? Icons.gps_fixed : Icons.search),
              onPressed: () {
                if (_currentPage == 1) {
                  context.read<GpsNotifier>().getCurrentLoc(() {}, () {});
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
      ),
    );
  }
}
