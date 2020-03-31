import 'package:diary/application/day_notifier.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/date_notifier.dart';
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
      // workaround per problema appbar con height errata in iphoneX
      // https://github.com/flutter/flutter/issues/26163#issuecomment-520161699
      child: SafeArea(
        top: false,
        child: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.85),
              elevation: 0,
              leading: IconButton(
                  color: accentColor,
                  icon: Icon(_currentPage == 0 ? Icons.map : Icons.arrow_back),
                  onPressed: () {
                    widget.changePage(_currentPage == 0 ? 1 : 0);
                    setState(() {
                      _currentPage = _currentPage == 0 ? 1 : 0;
                    });
                  }),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  FlatButton.icon(
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate:
                            Provider.of<DateState>(context, listen: false)
                                .selectedDate
                                .withoutMinAndSec(),
                        firstDate: dates.first,
                        lastDate: dates.last.add(Duration(minutes: 1)),
                        selectableDayPredicate: (DateTime date) =>
                            dates.contains(
                          date.withoutMinAndSec(),
                        ),
                        // datepicker manual customization (it is a flutter bug):
                        // https://github.com/flutter/flutter/issues/19623#issuecomment-568009162)
                        builder: (context, child) => Theme(
                          data: ThemeData(
                            fontFamily: "Nunito",
                            primarySwatch: Colors.blueGrey,
                            primaryColor: accentColor, //  HEADER COLOR
                            accentColor: accentColor, // DATE COLOR
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.accent,
                            ),
                          ),
                          child: child,
                        ),
                      );

                if (selected == null) return;
                Provider.of<DayNotifier>(context, listen: false)
                    .changeDay(selected);
              },
    shape: RoundedRectangleBorder(
    borderRadius: new BorderRadius.circular(16.0),
    ),
    icon: Icon(
    Icons.today,
    color: accentColor,
    ),
    label: Text(
    context.select((DateState value) =>
    value.isToday ? 'Oggi' : value.dateFormatted),
    style: TextStyle(
    color: accentColor,
    fontSize: 20,
    fontWeight: FontWeight.bold)),
    ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),

              actions: <Widget>[
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
                  getCurrentLoc();
                } else {
                  widget.changePage(2);
                  setState(() {
                    _currentPage = 2;
                  });
                }
              },
            ),

//            IconButton(
//                color: isMoving ? Colors.green : Colors.red,
//                icon: Icon(Icons.directions_walk),
//                onPressed: () {
//                  bg.BackgroundGeolocation.changePace(!isMoving);
//                  isMoving = !isMoving;
//                  setState(() {
//
//                  });
//                }
              ]),
        ),
      ),
    );
  }

  getCurrentLoc() {
    LocationUtils.getCurrentLocationAndUpdateMap((bg.Location location) {
      print('[getCurrentPosition] - $location');
    }, (error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }
}
