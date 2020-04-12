import 'package:diary/application/current_root_page_notifier.dart';
import 'package:diary/application/day_notifier.dart';
import 'package:diary/application/gps_notifier.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/application/root_elevation_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/utils/extensions.dart';
import 'package:provider/provider.dart';

class MyDayAppBar extends StatefulWidget {
  const MyDayAppBar({Key key}) : super(key: key);

  @override
  _MyDayAppBarState createState() => _MyDayAppBarState();
}

class _MyDayAppBarState extends State<MyDayAppBar> {
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
    int _currentPage = context.watch<CurrentRootPageState>().currentPage;
    final dates = Provider.of<LocationNotifier>(context, listen: false).dates;

    return
      // workaround per problema appbar con height errata in iphoneX
      // https://github.com/flutter/flutter/issues/26163#issuecomment-520161699
       SafeArea(
        top: false,
        child: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.color.withOpacity(0.85),
              elevation:
                  context.watch<ElevationState>().elevations[_currentPage],
              leading: (_currentPage == 0)
                  ? IconButton(
                      icon: Icon(CustomIcons.map_outline),
                      onPressed: () {
                        context.read<CurrentRootPageNotifier>().changePage(1);
                      })
                  : IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        context.read<CurrentRootPageNotifier>().changePage(0);
                      }),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  FlatButton.icon(
                    highlightColor: Theme.of(context).textTheme.body1.color.withOpacity(0.3),
                    splashColor: Theme.of(context).textTheme.body1.color.withOpacity(0.3),
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
                            primaryColor: Colors.white,
                            //  HEADER COLOR
                            accentColor: accentColor,
                            // DATE COLOR
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
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    icon: Icon(
                      CustomIcons.calendar_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    label: Text(
                        context.select((DateState value) =>
                            value.isToday ? 'Oggi' : value.dateFormatted),
                        style: Theme.of(context).textTheme.title
                    )
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
                if (_currentPage == 0)
                  IconButton(
                      icon: Icon(CustomIcons.bookmark_multiple_outline),
                      onPressed: () {
                        context.read<CurrentRootPageNotifier>().changePage(2);
                      })
                else if (_currentPage == 1)
                  IconButton(
                      icon: Icon(Icons.gps_fixed),
                      onPressed: () {
                        context
                            .read<GpsNotifier>()
                            .getCurrentLoc((location) {}, (error) {});
                      })
                else if (_currentPage == 2)
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {})
              ]),

      ),
    );
  }
}
