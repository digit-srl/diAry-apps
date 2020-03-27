
import 'package:diary/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/root/date_notifier.dart';
import 'package:diary/utils/extensions.dart';
import 'package:provider/provider.dart';

class CalendarButton extends StatefulWidget {
  @override
  _CalendarButtonState createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  @override
  Widget build(BuildContext context) {
    final dates = Provider.of<LocationNotifier>(context, listen: false).dates;

    return Row(
      children: <Widget>[
        Expanded(child: Container()),
        FlatButton(
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
            borderRadius: new BorderRadius.circular(8.0),
          ),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.keyboard_arrow_down,
                color: accentColor,
              ),
              Text(
                context.select((DateState value) =>
                    value.isToday ? 'Oggi' : value.dateFormatted),
                style: TextStyle(
                    color: accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
