import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/custom_icons.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.locations.length,
      onPageChanged: (index) {
        widget.selectPin(widget.locations[index]);
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () {
                          //TODO change to animatedPage
                          if (itemIndex > 0) {
                            _pageController.jumpToPage(itemIndex - 1);
                          }
                        }),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          CustomIcons.pin_outline,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AutoSizeText(
                            "Pin",
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headline,
                          )),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AutoSizeText(
                          (itemIndex + 1).toString() +
                              "/" +
                              widget.locations.length.toString(),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline,
                        )),
                    IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {
                          //TODO change to animatedPage
                          if (itemIndex < widget.locations.length - 1) {
                            _pageController.jumpToPage(itemIndex + 1);
                          }
                        }),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Icon(
                          Icons.data_usage,
                        )),
                    Expanded(
                      child: AutoSizeText(
                        widget.locations[itemIndex].uuid,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Icon(
                          Icons.access_time,
                        )),
                    Expanded(
                      child: AutoSizeText(
                        dateFormat.format(widget.locations[itemIndex].dateTime),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.pin_drop,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        'Lat: ${widget.locations[itemIndex].coords.latitude.toStringAsFixed(2)} Long: ${widget.locations[itemIndex].coords.longitude.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.body1,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.gps_fixed,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        'Accuratezza: ${widget.locations[itemIndex].coords.accuracy} m',
                        style: Theme.of(context).textTheme.body1,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Icon(
                        Icons.event,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        'Evento: ${widget.locations[itemIndex].event.toString().replaceFirst('Event.', '')}',
                        style: Theme.of(context).textTheme.body1,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                if (widget.locations[itemIndex]?.activity != null)
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Icon(
                          Icons.directions_walk,
                        ),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          'Attività: ${widget.locations[itemIndex].activity.type.toUpperCase()} al ${widget.locations[itemIndex].activity.confidence.toInt()} %',
                          style: Theme.of(context).textTheme.body1,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                if (widget.locations[itemIndex]?.battery != null)
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
                        child: Icon(
                          widget.locations[itemIndex].battery.isCharging
                              ? Icons.battery_charging_full
                              : Icons.battery_std,
                        ),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          '${(widget.locations[itemIndex].battery.level * 100).toInt()} %',
                          style: Theme.of(context).textTheme.body1,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
              ],
            ));
      },
    );
  }
}
