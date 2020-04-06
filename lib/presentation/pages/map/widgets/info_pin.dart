import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoPinWidget extends StatefulWidget {
  final List<Location> locations;
  final Function selectPin;
  final int initialPage;
  InfoPinWidget({Key key, this.locations, this.selectPin, this.initialPage})
      : super(key: key);

  @override
  _InfoPinWidgetState createState() => _InfoPinWidgetState();
}

class _InfoPinWidgetState extends State<InfoPinWidget> {
  final DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');

  PageController _pageController;

  _InfoPinWidgetState();

  int page;
  @override
  void initState() {
    super.initState();
    page = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
//    _pageController.addListener(() {
//      page = _pageController.page.toInt();
//      widget.selectPin(widget.locations[page]);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.locations.length,
      onPageChanged: (index) {
        print('change page to $index');
        page = index;
        widget.selectPin(widget.locations[index]);
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
//            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () {
                        //TODO change to animatedPage
                        if (page > 0) {
                          _pageController.jumpToPage(page - 1);
                        }
                      }),
                  Spacer(),
                  Text(page.toString()),
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.arrow_forward),
                      color: Colors.black,
                      onPressed: () {
                        //TODO change to animatedPage
                        if (page < widget.locations.length) {
                          _pageController.jumpToPage(page + 1);
                        }
                      }),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.data_usage)),
                  Expanded(
                    child: AutoSizeText(
                      widget.locations[itemIndex].uuid,
                      maxLines: 1,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.timelapse,
                    ),
                  ),
                  Text(dateFormat.format(widget.locations[itemIndex].dateTime)),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.pin_drop,
                    ),
                  ),
                  Text(
                      'Lat: ${widget.locations[itemIndex].coords.latitude.toStringAsFixed(2)} Long: ${widget.locations[itemIndex].coords.longitude.toStringAsFixed(2)}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.gps_fixed,
                    ),
                  ),
                  Text(
                      'Accuratezza: ${widget.locations[itemIndex].coords.accuracy} m'),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.event,
                    ),
                  ),
                  Text(
                      'Evento: ${widget.locations[itemIndex].event.toString().replaceFirst('Event.', '')}'),
                ],
              ),
              if (widget.locations[itemIndex]?.activity != null)
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.directions_walk,
                      ),
                    ),
                    Text(
                        'Attività: ${widget.locations[itemIndex].activity.type.toUpperCase()} al ${widget.locations[itemIndex].activity.confidence.toInt()} %'),
                  ],
                ),
              if (widget.locations[itemIndex]?.battery != null)
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        widget.locations[itemIndex].battery.isCharging
                            ? Icons.battery_charging_full
                            : Icons.battery_std,
                      ),
                    ),
                    Text(
                        '${(widget.locations[itemIndex].battery.level * 100).toInt()} %'),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
