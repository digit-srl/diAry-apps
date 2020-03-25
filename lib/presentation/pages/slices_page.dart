import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/root/date_notifier.dart';
import 'package:provider/provider.dart';

class SlicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final day = Provider.of<LocationNotifier>(context, listen: false).getDay();
    return Scaffold(
      appBar: AppBar(
        title: Text('Spicchi giornalieri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: day.slices
              .map(
                (slice) => Card(
                  child: ListTile(
                    leading: Text(slice.id.toString()),
                    title: Row(
                      children: <Widget>[
                        Text(
                          slice.activity
                              .toString()
                              .replaceFirst('MotionActivity.', ''),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text('  ->  '),
                        Text(slice.formattedMinutes),
                      ],
                    ),
                    subtitle: Text(slice.startTime.toString()),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
