import 'package:diary/domain/entities/location.dart';
import 'package:diary/domain/entities/place.dart';
import 'package:diary/utils/import_export_utils.dart';
import 'package:diary/application/day_notifier.dart';
import 'package:diary/domain/entities/motion_activity.dart';
import 'package:diary/domain/entities/slice.dart';
import 'package:diary/utils/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart' as pro;

class TabBarDemo extends StatefulWidget {
  final List<Slice> places;
  final List<Slice> slices;
  final List<Location> locations;

  const TabBarDemo({Key key, this.places, this.slices, this.locations})
      : super(key: key);

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  List<Slice> places = [];
  List<Slice> slices = [];
  DateTime date;

  @override
  void initState() {
    super.initState();

    if (widget.locations != null) {
      updateSlices();
    } else {
      final day = pro.Provider.of<DayState>(context, listen: false).day;
      slices = List.from(day.slices);
      places = List.from(day.places);
    }
    date = slices.isNotEmpty ? slices?.first?.startTime : DateTime.now();
  }

  updateSlices() async {
    final output = LocationUtils.aggregateLocationsInSlices3(
      widget.locations,
    );
    slices = output.slices;
    places = output.places;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.timelapse)),
              Tab(icon: Icon(Icons.place)),
            ],
          ),
          title: Text('Spicchi giornalieri ${date.day}'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                  widget.locations != null ? Icons.update : Icons.file_upload),
              color: Colors.black,
              onPressed: widget.locations != null
                  ? () async {
                      await updateSlices();
                      setState(() {});
                    }
                  : _importJson,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SlicesPage(
              slices: slices ?? widget.slices,
            ),
            SlicesPage(
              slices: places ?? widget.places,
              isPlace: true,
            ),
          ],
        ),
      ),
    );
  }

  _importJson() async {
    final locations = await ImportExportUtils.importJSON();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return TabBarDemo(
        locations: locations,
      );
    }));
  }
}

class SlicesPage extends StatelessWidget {
  final bool isPlace;
  final List<Slice> slices;

  const SlicesPage({Key key, this.isPlace = false, this.slices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (slices.isNotEmpty &&
        slices.last.activity == MotionActivity.Unknown &&
        !isPlace) {
      slices.removeLast();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: slices.isEmpty
            ? Center(
                child: Text('Non ci sono spicchi temporali per questo giorno'),
              )
            : ListView(
                children: slices
                    .map(
                      (slice) => Card(
                        color: slice.activity == MotionActivity.Off
                            ? Colors.red
                            : null,
                        child: ListTile(
                          leading: Text(slice.placeRecords.toString()),
                          title: Row(
                            children: <Widget>[
                              Text(
                                getText(slice),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              Text('  ->  '),
                              Text(slice.formattedMinutes),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(slice.activity
                                  .toString()
                                  .replaceFirst('MotionActivity.', '')),
                              Text(slice.startTime.toString()),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }

  getText(Slice slice) {
    if (isPlace) {
      Set<String> list = {};
      slice.places.forEach((identifier) {
//        list.add(identifier);
        list.add(Hive.box<Place>('places').get(identifier).name);
      });
      return list.toString();
    }

    return slice.activity.toString().replaceFirst('MotionActivity.', '');
  }
}
