import 'package:diary/application/service_notifier.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/root/date_notifier.dart';
import 'package:diary/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class CalendarButton extends StatefulWidget {
  @override
  _CalendarButtonState createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  @override
  Widget build(BuildContext context) {
    final dates = Provider.of<LocationNotifier>(context, listen: false).dates;
    bool isMoving = false;

    return Row(
      children: <Widget>[
        Expanded(child: Container()),
        FlatButton.icon(
          onPressed: () async {
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

    /* todo decommentare per gps fittizio
        IconButton(
            icon: Icon(Icons.change_history),
            onPressed: () {
              Provider.of<ServiceNotifier>(context, listen: false)
                  .invertEnabled();
              Provider.of<LocationNotifier>(context, listen: false)
                  .addLocation(null);
            }),
        IconButton(
            color: isMoving ? Colors.green : Colors.red,
            icon: Icon(Icons.directions_walk),
            onPressed: () {
              bg.BackgroundGeolocation.changePace(!isMoving);
              setState(() {
                isMoving = !isMoving;
              });
            }),
    */

        Expanded(child: Container()),
      ],
    );
  }
}
